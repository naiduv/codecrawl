# Sketchup To AC3D Exporter Version 0.1
# written by James Turner, zakalawe@_delete_this_.mac.com
# Copied from the OGRE exporter originally, but totally re-written
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place - Suite 330, Boston, MA 02111-1307, USA, or go to
# http://www.gnu.org/copyleft/lesser.txt.

module AC3D

# store info about a face to be exported - the face itself and its
# transformation
class FaceInfo
  attr_reader :face, :trans
  
  def initialize(f, t)
    @face = f
    @trans = t
  end
end

# used to combine co-incident points from multiple faces into a single
# AC3D object, and write out the vertices appropriately
class Vertices
  def initialize()
    @points = []
    @transform = Geom::Transformation.new
  end
  
  def get_point(p)
    q = p.transform @transform
    @points.each_with_index do |pt, index|
      if pt == q
        return index
      end
    end
    
    @points << q
    return @points.size - 1
  end
  
  def set_transform(t)
    @transform = t
  end
  
  def write(out)
    out.print "numvert #{@points.size}\n"
    @points.each do |p|
      out.printf("%6f %6f %6f\n", p.x.to_m, p.y.to_m, p.z.to_m)
    end
  end
end

# encapsulation of an AC3D surface (SURF) element, created from
# a single PolyMesh polygon
class Surface
  def initialize(material, mesh, poly, vertices)
    @material = material
    @vertices = []
    @have_texture = false
    uv_scale = $g_material_manager.uv_scale(material)
    
    if uv_scale
      # have texture, extract UVs
      @have_texture = true
      for v in poly
        # true for front face in uv_at
        # .transform uv_scale 
        uv = mesh.uv_at(v, true)
        pt = mesh.point_at(v)
        @vertices << [vertices.get_point(pt), uv.x.to_f, uv.y.to_f];
      end
    else
      # no texture, ignore UVs
      for v in poly
        pt = mesh.point_at(v)
        @vertices << vertices.get_point(pt);
      end
    end
  end
  
  def write(out)
    out.print "SURF 0x30\n"
    out.print "mat #{@material}\n"
    out.print "refs #{@vertices.size}\n"
    
    if @have_texture
      for v in @vertices
        out.printf("%d %4.4f %4.4f\n", v[0], v[1], v[2])
      end
    else
      @vertices.each {|v| out.printf("%d 0 0\n", v)}
    end
  end
end

class CreaseContext
  def initialize()    
    @upper_smooth_angle = 0 # 0 degrees
    @lower_hard_angle = Math::PI # 180 degrees
    @seen = [] # previously scanned faces
  end
  
  # scan a single face, look at each edge in turn
  def scan_face(face)
    @seen << face
        
    face.edges.each do |edge|
      edge.faces.each do |f2|
        if f2 == face or !@seen.include? f2
          next # both faces must be in the seen list
        end
        
        submit_edge(edge, face, f2)
      end
    end # of iteration over face's edges
  end
  
  def submit_edge(edge, face1, face2)
    angle = face1.normal.angle_between face2.normal
    if angle == 0.0
      # co-planar faces can be ignored completely - they look the same
      # regardless, and it's common to have non-smooth co-planar faces
      return 
    end
    
    if edge.smooth?
      if angle > @upper_smooth_angle
        #puts "increasing smooth angle to #{angle.radians}"
        @upper_smooth_angle = angle
      end
    elsif angle < @lower_hard_angle
      #puts "decreasing hard angle to #{angle.radians}"
      @lower_hard_angle = angle
    end
  end
  
  def write(out)
    if @upper_smooth_angle == 0
      return # no smooth angles at all
    end
    
    if @lower_hard_angle < @upper_smooth_angle
      puts "couldn't partition edges on an angle: bad!"
      puts "upper smooth angle: #{@upper_smooth_angle.radians}"
      puts "lower hard angle: #{@lower_hard_angle.radians}"
      return
    end
    
    # split the difference
    crease = (@lower_hard_angle + @upper_smooth_angle) / 2
    out.print "crease #{crease.radians}\n"
  end
end

class MaterialManager
  def initialize()
    @sku_materials = {}
    @materials = []
    @materials << nil
    @texture_writer = Sketchup.create_texture_writer
    @textures = []
  end
  
  def add_drawing_element(elem)
    if !elem or !(elem.kind_of? Sketchup::Drawingelement)
      # base case if we recurse too far
      return 0 #default material
    end
    
    if elem.material
      return add_material(elem)
    else
      # recurse up the parent chain to find a material
      return add_drawing_element(elem.parent)
    end
  end
  
  def add_material(elem)
    mat = elem.material
    if @sku_materials.has_key?(mat)
      return @sku_materials[mat]
    else
      @sku_materials[mat] = @materials.size
      @materials << mat
      
      if mat.texture
        # write out texture
        @texture_writer.load(elem, true)

        dest_file = texture_filename(mat.texture)
        puts dest_file
        dest_path = File.join($output_dir, dest_file)
      
        if !File.exist? dest_path
          @texture_writer.write(elem, true, dest_path)
        end
        @textures << dest_path
      end
    
      return @materials.size - 1
    end
  end
  
  def write(out)
    @materials.each do |mat|
      if mat
        mat_name = mat.display_name #fixme, remove spaces, etc
        col = mat.color

        out.print "MATERIAL \"#{mat_name}\""
        out.printf(" rgb %4.4f %4.4f %4.4f", col.red/255.0, col.green/255.0, col.blue/255.0)
        out.print " amb 0.4 0.4 0.4"
        out.print " emis 0 0 0"
        out.print " spec 0.2 0.2 0.2 shi 128"
        out.printf(" trans %4.4f", 1.0 - col.alpha/255.0)
        out.print "\n"
      else
        #default material
        out.print "MATERIAL \"default\" rgb 0.5 0.5 0.5 amb 0.4 0.4 0.4 emis 0 0 0 spec 0.2 0.2 0.2 shi 128 trans 0\n"
      end
    end
  end
  
  def texture_filename(tex)
    last_slash = tex.filename.rindex(/[\\\/]/)
    if last_slash != nil
      result = tex.filename[last_slash+1..-1]
    else
      # filename doesn't contain a directory at all
      result = tex.filename
    end
    
    result.sub!(/[ ]/, "_") # replace nasty characters with underscores
    return result
  end
  
  def texture_name(material_index)
    tex = texture(material_index)
    if !tex
      return nil  
    end
    
    n = texture_filename(tex)
    return File.basename(n, File.extname(n)) + ".rgb"
  end
  
  def uv_scale(material_index)
    tex = texture(material_index)
    if !tex
      return nil  
    end
    
    # scale UVs by texture size in internal lengths
    return Geom::Transformation.scaling(1.0 / tex.width, 1.0 / tex.height, 1.0)
  end
  
  def texture(index)
   if (index < 1) or (index >= @materials.size)
      return nil
    end

    return @materials[index].texture
  end
  
  def convert_textures_to_sgi
    @textures.each do |t|
      dir = File.dirname(t)
      output_path = File.join($output_dir, File.basename(t, File.extname(t)) + ".rgb")
      if !system("convert", t, "sgi:" + output_path)
        puts $?
      end
    end
  end
end

def self.export_faces(out,faces,material)
  name = "blah"
  texture = $g_material_manager.texture_name(material)
  crease = CreaseContext.new
  faces.each {|f| crease.scan_face(f.face) }
  
  out.print "OBJECT poly\n"
  out.print "name \"#{name}\"\n"
  if texture
    out.print "texture \"#{texture}\"\n"
  end
  
  crease.write(out)
  surfaces = []
  combiner = Vertices.new()
  
  for finfo in faces
    # magic '7' argument t face.mesh makes UVs work - no idea why
    mesh = finfo.face.mesh 7 
    combiner.set_transform(finfo.trans)
  
    for poly in mesh.polygons
      surfaces << Surface.new(material, mesh, poly, combiner)
    end
  end
  
  combiner.write(out)
  out.print "numsurf #{surfaces.size}\n"
  surfaces.each {|surface| surface.write(out)}
  out.print  "kids 0\n"
end

def self.traverse_entity(ent, transform, faces)
  ec = ent.class
  
  if (ec == Sketchup::Face)
    materialIndex = $g_material_manager.add_drawing_element(ent)
    if (!faces[materialIndex])
      faces[materialIndex] = []
    end
    
    # record face and transform for export
    faces[materialIndex] << FaceInfo.new(ent, transform);
  end
  
  #recurse over children
  if (ec == Sketchup::Group)
    ct = transform * ent.transformation
    ent.entities.each{|child| traverse_entity(child, ct, faces)} 
  elsif (ec == Sketchup::ComponentInstance)
    ct = transform * ent.transformation
    ent.definition.entities.each{|child| traverse_entity(child, ct, faces)}
  end
end

# The main export procedure, called by menu selection.
def self.export

  faces = {}
  entities = []
  $g_material_manager = MaterialManager.new()
  
  title = Sketchup.active_model.title
  title = "Untitled" if title.length == 0
  filename = UI.savepanel("Filename", nil, "#{title}.ac")
  if !filename
    return # user cancelled
  end
  
  $output_dir = File.dirname(filename)
  
  if Sketchup.active_model.selection.empty?
    # no selection, just use everything
    entities = Sketchup.active_model.entities
  else
    # valid selection, use it
    entities = Sketchup.active_model.selection 
  end
  
  origin = Geom::Point3d.new
  x_axis = Geom::Vector3d.new(1,0,0)
  t = Geom::Transformation.rotation(origin, x_axis, -90.degrees)
  
  entities.each {|e| traverse_entity(e, t, faces)}
    
  out = open(filename, "w")
  out.print "AC3Db\n"
  
  $g_material_manager.write(out)
  
  out.print "OBJECT world\n"
  out.print "kids #{faces.size}\n"
  faces.each_pair {|mat, faces| export_faces(out, faces, mat)}
  
  out.print "\n" #output trailing LF
  out.close
  
  $g_material_manager.convert_textures_to_sgi
  puts "Export finished.\n"
end

end # module AC3D

if ($ac3d_export_loaded != true)
  UI.menu("Plugins").add_item("Export to AC3D") { AC3D::export }
  $ac3d_export_loaded = true
end
