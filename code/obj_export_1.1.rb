=begin
 obj_export Copyright (C) 2006 jim.foltz@gmail.com

 obj_export.rb - Simple export to Wavefront .obj file
 Supports v's and f's only.

 Does not support Textures, Groups or Components. You must explode all 
 geometry before exporting.

=end

require "sketchup.rb"
module JF

  def self.obj_export2

    title = Sketchup.active_model.title
    title = "Untitled" if title.length == 0
    file = UI.savepanel("Filename", nil, "#{title}.obj")
    #of = File.new("c:/tmp/test.obj", "w")
    of = File.new(file, "w")
    of.puts "# Wavefront OBJ created by #{File.basename(__FILE__)} for SketchUp"
    of.puts "# Copyright (C) 2006 jim.foltz@gmail.com\n#\n"

    grps = Sketchup.active_model.entities.find_all{|e| e.typename == "Group"}
    cmps = Sketchup.active_model.entities.find_all{|e| e.typename == "ComponentInstance"}

    @verts = []
    @vcnt = 0
    entities = Sketchup.active_model.entities
    export_entities(of, entities)

    grps.each {|g| export_group(of, g) }
    cmps.each {|c| export_ci(of, c) }

    of.flush
    of.close
    UI.beep
  end

  def self.export_ci(of, ci)
    o = ci.transformation
    p o.to_a
    of.print "g "
    id = ci.entityID
    of.puts "#{id}"
    export_entities(of, ci.definition.entities, o)
  end

  def self.export_group(of, g)
    o = g.transformation
    of.print "g "
    id = g.entityID
    name = g.name.empty? ? "Group#{id}" : g.name
    of.puts "#{name}"
    export_entities(of, g.entities, o)
  end

  def self.export_entities(of, entities, o=nil)

    faces = entities.find_all { |e| e.typename == "Face"}
    verts = faces.map { |f| f.vertices }
    verts.flatten!
    verts.uniq!

    if verts.length < 1
      #UI.messagebox("Nothing to export")
      #return
    end

    verts.each do |v|
      pt = v.position 
      pt.transform!(o) if o
      of.print "v #{pt.x.to_f}  #{pt.y.to_f} #{pt.z.to_f}\n"
    end

    gc = 0
    puts "face count: #{faces.length}"
    faces.each do |f|
      gc += 1
      #of.print "g face#{gc}\n"
      of.print "f "
      f.outer_loop.vertices.each do |v|
	#corner_vertices(f).each do |v|
	i = verts.index(v) + @verts.length
	of.print "#{i+1} "
      end
      of.puts
    end
    of.puts
    @verts << verts
    @verts.flatten!

  end

end # module JF

sn = "obj_export_1.1.rb"
unless file_loaded? sn
  UI.menu("Plugins").add_item(sn) { JF::obj_export2 }
  file_loaded sn
end
