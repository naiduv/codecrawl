require 'sketchup'


=begin
for each model
  load model
  load cameras
  for each camera
    save image of all objects
    save image of all component objects (with non-components hidden)
    save sample points with projections
    save camera stats
    save smart bounding box

    for each object
      save image of that object with the others hidden
      save projected smart bounding box
=end


=begin
  BEGIN MODULE DEFINITION SECTION
=end


module CamUtils

  def CamUtils.getProjection(x)
    view = Sketchup.active_model.active_view
    return view.screen_coords(x)
  end


  def CamUtils.sample_projection_function()

    # get sample points
    points = []

    25.times {
      pt = Geom::Point3d.new(rand(100), rand(100), rand(100))

      points.push(pt)
    }

    # generate the output
    upoints = []
    xpoints = []
    n = points.length()

    points.each do |pt|

      view = Sketchup.active_model.active_view
      p = view.screen_coords(pt)
      upt = [p.x.to_f, p.y.to_f, 1]
      xpt = [pt.x.to_f, pt.y.to_f, pt.z.to_f, 1]

      upoints.push(upt)
      xpoints.push(xpt)

    end

    return [xpoints, upoints]

  end

  def CamUtils.saveCamStats(fileName)
    File.open(fileName, 'w') do |f|
      view = Sketchup.active_model.active_view
      cam = view.camera
      f.puts( "c_x=" + cam.xaxis.to_a.join(" "))
      f.puts( "c_y=" + cam.yaxis.to_a.join(" "))
      f.puts( "c_z=" + cam.zaxis.to_a.join(" "))
      f.puts( "cam_pos=" + cam.eye.to_a.join(" "))
      f.puts( "screen_center=" + view.center.to_a.join(" "))


      # to compute pixel width and height
      diag = cam.target + Geom::Vector3d.linear_combination(1.0, cam.xaxis.normalize, 1.0, cam.yaxis.normalize)
      diag = cam.target + cam.xaxis.normalize + cam.yaxis.normalize

      newPoint = Geom::Point3d.new(diag)
      scr_co = view.screen_coords(newPoint) - view.center
      f.puts( "% pixel ratio\n")
      f.puts( "u=" + scr_co.to_a.join(" "))

      f.puts( "f=" + cam.focal_length.to_s)
    end
  end




  # creates two files from the base filename:
  #  .x.dat contains world coordinates of points
  #  .u.dat contains the corresponding projected coordinates
  def CamUtils.saveCameraSamples(fileName)

    xfname = fileName + ".x.dat"
    ufname = fileName + ".u.dat"

    data = sample_projection_function()

    xpoints = data[0]
    upoints = data[1]

    File.open(xfname, 'w') do |f|
      temp_arr = (xpoints.map { |v| v.join(" ") })
      st = temp_arr.join("\n")
      f.puts(st)
    end

    File.open(ufname, 'w') do |f|
      temp_arr =(upoints.map { |v| v.join(" ") }) 
      st = temp_arr.join("\n")
      f.puts(st)
    end

  end
end

####################################
module ObjectUtils

  # gets the true corners of the bounding box for a definition instance
  #  transforms the object (to standard coords)
  #  gets the corners
  #  transforms the object and corners back to actual coordinates
  def ObjectUtils.getCorners(ob)

    # standardize view
    transform = ob.transformation
    ob.transform!(transform.inverse)

    # get the corners of the bounding box
    x = []
    0.upto(7) {|i|
      c = ob.bounds.corner(i)
      x << Geom::Point3d.new(c.x, c.y, c.z)
    }

    # transform the corners
    x.map{|i| i.transform!(transform)}
    ob.transform!(transform)

    return x
  end




  # returns an array of arrays: [comps, non_comps]
  def ObjectUtils.getComponentList()
    comps = []
    non_comps = []

    ents = Sketchup.active_model.entities
    for e in ents
      if (e.hidden?)
        next
      end


      type = e.typename

      if type == "ComponentInstance"
        comps << e
      else
        non_comps << e
      end

    end
    return [comps, non_comps]
  end



  def ObjectUtils.hide(obj)
    obj.hidden = true
  end


  def ObjectUtils.show(obj)
    obj.hidden = false
  end

end

####################################

module ModelUtils

  def ModelUtils.loadModel(fileName)
    file = Sketchup.open_file(fileName)
  end

  def ModelUtils.activeModel()
    return Sketchup.active_model
  end

  def ModelUtils.saveImage(fileName)
    Sketchup.active_model.active_view.write_image(fileName)
  end

end



=begin
  END MODULE DEFINITION SECTION
=end





def label3d(point, label)
      def pt(x, y, z)
        return Geom::Point3d.new([x, y, z])
      end
      entities = Sketchup.active_model.entities
      group = entities.add_group

      group.entities.add_3d_text(label, TextAlignLeft, "Arial", true, false, 6.0, 0.0, 0.5, true, 0.0)

      # create background
      bbox = group.bounds
      zeps = 1 
      xeps = 0.5 
      face = group.entities.add_face(pt(-xeps, -xeps, zeps), pt(-xeps, bbox.max.y + xeps, zeps), pt(bbox.max.x + xeps, bbox.max.y + xeps, zeps), pt(bbox.max.x + xeps, -xeps, zeps))
      group.material= "red"
      face.material= "white"


      cam = Sketchup.active_model.active_view.camera

      t = Geom::Transformation.new(cam.xaxis, cam.yaxis, cam.zaxis, point)
      group = group.transform!(t)
end

def bbox()
  comps, non_comps = ObjectUtils.getComponentList()
  comps.each {|x|
    corners = ObjectUtils.getCorners(x)
    corners.map{|y| label3d(y, 'x')}
  }
end









def saveStats()
  modelDir = "/Users/dave/model_data/models_skp/"
  outputDir = "/Users/dave/model_data/stats/"

  models = ['006', '007', '008', '009', '010', '011', '012', '013', '014', '015']
  
  models.each do |model|
    

    #model = File.basename(Sketchup.active_model.path, ".skp")


    # load the model and get components
    ModelUtils.loadModel(modelDir + model + ".skp")
    comps, non_comps = ObjectUtils.getComponentList()


    # save image of all objects
    view = 0
    part = "all"
    name = "#{model}_part#{part}_view#{view}"
    ModelUtils.saveImage(outputDir + name + ".jpg")


    # save image of all component objects (with non-components hidden)
    part = "allComps"
    name = "#{model}_part#{part}_view#{view}"

    non_comps.map{|x| ObjectUtils.hide(x)}
    ModelUtils.saveImage(outputDir + name + ".jpg")
    non_comps.map{|x| ObjectUtils.show(x)}

    # save sample points with projections
    name = "#{model}_view#{view}"
    CamUtils.saveCameraSamples(outputDir + name + ".samples")

    # save camera stats
    name = "#{model}_view#{view}"
    CamUtils.saveCamStats(outputDir + name + ".camStats")


    # process entities
    name = "#{model}_view#{view}"
    File.open(outputDir + name + ".entityInfo.dat", 'w') do |f|
      bbox = ModelUtils.activeModel().bounds
      f.syswrite("-1" + "\t" + "ENTIRE_MODEL" + "\t" + bbox.min.to_s + "\t" + bbox.max.to_s + "\n")

      (comps | non_comps).map{|x| ObjectUtils.hide(x)}
      comps.each_index do |part|
        name = "#{model}_part#{part}_view#{view}"

        obj = comps[part]
        corners = ObjectUtils.getCorners(obj)

        # save bounding box corners
        cornerStr = corners.join("\t")
        f.syswrite(part.to_s + "\t" + obj.definition.name.to_s + "\t" + cornerStr + "\n")

        # save image of object
        # ObjectUtils.show(obj)
        # ModelUtils.saveImage(outputDir + name + ".jpg")
        # ObjectUtils.hide(obj)
      end # comps.each_index
      (comps | non_comps).map{|x| ObjectUtils.show(x)}
    end # file.open


    # save projected bounding box corners
    name = "#{model}_view#{view}"
    File.open(outputDir + name + ".projectedEntityInfo.dat", 'w') do |f|
      comps.each_index do |part|
        obj = comps[part]
        corners = ObjectUtils.getCorners(obj)
        corners.map!{|x| CamUtils.getProjection(x)}

        cornerStr = corners.join("\t")

        f.syswrite(part.to_s + "\t" + cornerStr + "\n")
      end # comps.each_index
    end 


    puts "Done processing #{model}."
  end 

end


if (! file_loaded?(__FILE__)) then
  file_loaded(__FILE__)

  UI.menu("PlugIns").add_item("Save Stats") {
    saveStats()
  }

  UI.menu("PlugIns").add_item("Label BBox Corners") {
    bbox()
  }
end

