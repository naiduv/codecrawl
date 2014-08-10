# Ruby 
# cam2modo.rb
#------------------------------------------------------
# Export current view in SketchUp
# to a python script which creates a new camera in modo
#------------------------------------------------------
# Version: 1.02
# Author: grant marshall


require 'sketchup.rb'

def cam2modo

 # Warning message pop-up. If units precision is not set to maximum
 # SU may prefix the camera position distances with a tilde (~) 
 # indicating that they have been rounded. The tilde will cause 
 # the values to fail in modo.

 UI.messagebox "Please ensure that your Model Info>Units are set to Decimal Meters and Precision is set to maximum. 
 (Cancel the next dialog and change these settings if necessary)."

 model = Sketchup.active_model
 view = model.active_view
 camera = view.camera

 # Dialog for python script name and path. A default name is given because 
 # this is a one-off use .py script and you'll probably overwrite the old one every time
 value = UI.savepanel("Export Camera to Python script", "", "SUcam_2_modo.py")

 if value
  # create python script file
  camscript = File.new(value.to_s, "w")

  # write python script head
  camscript.puts("#python")
  camscript.puts("#This file was generated automatically")
  camscript.puts("#by the cam2modo.rb script for SketchUp")
  camscript.puts("#cam2modo.rb version: v1.01")
  camscript.puts("#cam2modo.rb author: grant marshall")
  camscript.puts("#cam2modo.rb date: 08/07/09") 
  camscript.puts
  camscript.puts("#--------------------------------------")
  camscript.puts
  camscript.puts("#Create new modo camera")
  camscript.puts
  camscript.puts("lx.eval('layer.newItem camera')")

  # Get camera eyepoint
  eye = camera.eye
  vx = eye.x
  vy = eye.y
  vz = eye.z

  # Get camera direction
  direction = camera.direction
  dx = direction.x
  dy = direction.y
  dz = direction.z

  # Get camera focal length
  foclen = (24.0/36.0)*camera.focal_length

  # Swap Y and Z axes for modo
  vy_modo = vz
  vz_modo = vy

  # Calculate Z-rotation of camera (will be Y-rotation in modo)
  rz = Math.atan2(dx,dy).radians

  # Calculate X-rotation
  rx = (Math.atan2(dz,Math.sqrt(dx*dx+dy*dy)).radians)

  # Write camera details to script
  camscript.puts("lx.eval('transform.channel pos.X [" + vx.to_s + "]')")
  camscript.puts("lx.eval('transform.channel pos.Y [" + vy_modo.to_s + "]')")
  camscript.puts("lx.eval('transform.channel pos.Z [-" + vz_modo.to_s + "]')")
  camscript.puts("lx.eval('transform.channel rot.Y [-" + rz.to_s + "]')")
    camscript.puts("lx.eval('transform.channel rot.X [" + rx.to_s + "]')")
  camscript.puts("lx.eval('item.channel camera$focalLen [" + foclen.to_s + "mm]')")  
  camscript.puts("lx.eval('item.channel apertureX [36 mm]')")
  camscript.puts("lx.eval('item.channel apertureY [24 mm]')")
  camscript.puts("lx.eval('item.channel camera$filmFit [2]')")

 end

 # ° symbol omitted from camera rotations because SketchUp2014's new version of Ruby didn't like them.
 #close file (python script)
 camscript.close

end

# Add menu item 
if (not file_loaded?("cam2modo.rb"))
 #add_separator_to_menu("Camera")
 UI.menu("Camera").add_item("Current view to modo") { cam2modo }
end

file_loaded("cam2modo.rb")

