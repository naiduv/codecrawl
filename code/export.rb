$: << "c:\\ruby\\lib\\ruby\\1.8"

puts $:
require 'rexml/document.rb'
include REXML
require 'sketchup.rb'
#require 'attributes.rb'

def export_file
	model = Sketchup.active_model
	export_doc = Document.new
	export_doc.add_element('root')
	export([model],export_doc.root)
	out = File.new("export/output.xml","w")
	export_doc.write(output=out,indent=4)
	out.close
	
	result=inputbox ["granularity"],[5],"Please specify the granularity size of the export."
	$stepsize=result[0]
	
	load 'image2D.rb'
	UI.messagebox "Export done."
end

def export(objects,tree)

mynode=Element.new("Group")

# if objects[-1].kind_of?(Sketchup::Group)
	# shoot(objects)
# end

tree << mynode

dict=objects[-1].attribute_dictionaries[$dictname]
dict.each_key {|a| mynode.add_attribute(a,objects[-1].get_attribute($dictname, a))}

if objects[-1].kind_of?(Sketchup::Entity)
	mynode.add_attribute("id",objects[-1].entityID);
end
#search all children of this object
ent=objects[-1].entities
#ignore anything that is not a Group
ent=ent.reject {|a| !a.kind_of?(Sketchup::Group) || a.name=~/Google Earth/ || a.get_attribute($dictname, 'name').nil?}

# caption=if object.kind_of?(Sketchup::Group)
# object.name
# else
# "root"
# end

ent.each {|a| export(objects.dup << a,mynode) }

end

if ! file_loaded?('attributes.rb')

	#add a menu item to export
	plugins_menu = UI.menu("Plugins")
	plugins_menu.add_item("Export") { export_file }


end

def select(object)
	ss = Sketchup.active_model.selection
	ss.clear
	ss.add(object)
	Sketchup.active_model.active_view.invalidate
end

def shot(name)
	view = Sketchup.active_model.active_view
	view.write_image(name)
end

def shoot(objects)
	select(objects[-1])
	names=objects.collect {|a| fullname(a)}
	# bug: no refresh : http://forum.sketchup.com/showthread.php?t=40113
	shot("illustrations/" + names.join("") + ".png")
end

def fullname(object)
	# if ! object.kind_of?(Sketchup::Model)
		# fullname(object.parent)
		# else
		# ""
	# end + 
	if object.get_attribute($dictname,'name')
		object.get_attribute($dictname,'name')
	else
		"anonymous"
	end
end