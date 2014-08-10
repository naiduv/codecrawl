=begin
Copyright (c) 2009 Gabriel Miller

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
=end

require "sketchup.rb"

      filename="CamBamExport-inch.rb"
   
   if !file_loaded?(filename)
       # get the SketchUp plugins menu
       plugins_menu = UI.menu("Plugins")
       # add a seperator and our function to the "plugins" menu
       if plugins_menu
           plugins_menu.add_item("CamBamExport-inch") {cambamexport_inch}
       end
       # Let Ruby know we have loaded this file
       file_loaded(filename)
     end
     
      def cambamexport_inch

model = Sketchup.active_model    




if model.title == ""
  file_name = 'CamBamExport'
  else
    file_name = model.title.to_s
end
title = file_name + '.cb'



# Output file
path_to_save_to = UI.savepanel "Save File", "c:\\", title

export_file = File.new(path_to_save_to, "w" )
export_file.puts "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
export_file.puts "<CADFile xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
export_file.puts "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" Name=\"" + file_name + "\" units=\"Inches\">"
export_file.puts "  <layers>"
export_file.puts "    <layer name=\"Default\" color=\"139,0,0\">"
export_file.puts "      <mat />"
export_file.puts "      <objects>"

x = 0

selection = model.selection
   remove_faces = []
   0.upto(selection.length) do |faces|
      remove_faces.push(selection[faces]) if(selection[faces].class == Sketchup::Face)
   end
   remove_faces.each {|faces2| selection.remove(faces2)}


selection.each { |entity| 
x = x + 1
export_file.puts"        <line id=\""+x.to_s+"\">"
export_file.puts"          <mat />"
export_file.puts"          <pts>"
export_file.puts'            <p>' + entity.vertices[0].position.x.to_f.to_s + ',' + entity.vertices[0].position.y.to_f.to_s+',' + entity.vertices[0].position.z.to_f.to_s+'</p>' 
export_file.puts'            <p>' + entity.vertices[1].position.x.to_f.to_s + ',' + entity.vertices[1].position.y.to_f.to_s+',' + entity.vertices[1].position.z.to_f.to_s+'</p>' 
export_file.puts"          </pts>"
export_file.puts"        </line>"

}


export_file.puts '      </objects>'
export_file.puts '    </layer>'
export_file.puts '  </layers>'
export_file.puts '  <ActiveLayer>Default</ActiveLayer>'
export_file.puts '</CADFile>'

export_file.close

end
