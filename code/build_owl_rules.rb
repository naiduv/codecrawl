require 'Tools'

if ARGV[0] == '-hermit' 
  ARGV.shift
  Tools.callHermiT(ARGV); 
  exit(0)
end

params = Tools.getParams(ARGV)

if !params[:no_reasoner]
  tools = Tools.new(params[:tool_params])
end

case params[:action]
  when 's'
    classes = tools.getSubClasses(params[:elementName], params[:all])
    puts "Class [#{params[:elementName]}]"
    tools.showSubClasses(classes, 1, params[:all])
  
  when 'S'
    classes = tools.getSuperClasses(params[:elementName], params[:all])
    puts ":#{params[:all]}: #{classes.to_a.map{|cc| cc.to_s}}"
    puts "Class [#{params[:elementName]}]"
    tools.showSuperClasses(classes, 1, params[:all])

    puts '-----------'
    classes = tools.getSuperClassesAsArray(params[:elementName])
    puts classes.inspect

  when 'p'
    properties = tools.getSubObjectProperties(params[:elementName], params[:all])
    puts "Property [#{params[:elementName]}]"
    tools.showSubProperties(properties, 1, params[:all])

  when 'P'
    properties = tools.getSuperObjectProperties(params[:elementName], params[:all])
    puts "Property [#{params[:elementName]}]"
    tools.showSuperProperties(properties, 1, params[:all])

  when 'c'
    puts "Getting Ontology in #{params[:conversion_format]}"
    puts "Output #{params[:output]}"
    tools.getOntologyFormatted(params[:conversion_format], params[:output], 0)

  when 'm'
    puts "Merging Ontologies"
    puts "Output: #{params[:output]}"
    xml = tools.mergeOntologies(params[:conversion_format], params[:output])

  when 'k'
    puts "Satisfy concept [#{params[:elementName]}]"
    res = tools.satisfyConcept(params[:elementName])
    if res
      puts '   yes'
    else
      puts '   no'
    end
    
  when 'K'
    res = tools.isConsistent()
    print "Is Ontrology Consistent? : "
    if res
      puts '   yes'
    else
      puts '   no'
    end
    
  when 'u'
    puts "Unsatisfiable Classes:"
    classes = tools.getUnsatisfiableClasses()
    classes.to_a.each {|c| puts c.getIRI()}
        
  when 'U'
    puts "Unsatisfiable Properties:"
    properties = tools.getUnsatisfiableProperties()
    properties.to_a.each {|c| puts c}
        
  when 'a'
    ontologyManager1=OWLManager.createOWLOntologyManager();  #OWLOntologyManager
    ontology1=ontologyManager1.loadOntology(tools.ontologies[0]); #OWLOntology

    ontologyManager2=OWLManager.createOWLOntologyManager();  #OWLOntologyManager
    ontology2=ontologyManager2.loadOntology(tools.ontologies[1]); #OWLOntology
#    ontology.getAxioms.to_a.each{|a| puts "#{a.inspect}\n   #{a}\n\n"}

    axioms = []

    ontology1.getEntitiesInSignature(IRI.create("http://www.csd.abdn.ac.uk/research/AgentCities/WeatherAgent/weather-ont.daml#Snow")).to_a.each do |e| 
      puts "#{e.inspect}\n - #{e}\n\n"
      ontology1.getReferencingAxioms(e).each do |a| 
        axioms << a
        puts "\t#{a.inspect}\n\t - #{a}\n\n"
        a.getReferencedEntities.each do |refe|
          puts "\t\t#{refe.inspect}\n\t\t - #{refe}\n\n"          
        end
      end
    end
       
 when 'g'
   ontologies = Tools.load_weka_graph(params[:conversion_format], params[:input], params[:elementName], params[:rule_outputs])
   
  when 'M'
    matched_properties = tools.extract_matched_properties(params[:M_inputs], params[:result_dir])
    final_matched_properties = tools.pick_best_matched_properties(params[:M_inputs], matched_properties, params[:result_dir])


 when 'N'
   tools.extract_matched_classes(params[:M_inputs], params[:input], params[:result_dir])
   
  when 'x'
    tools.getComments(params[:input])
   
end

#rules = tools.generateClassifier(classes)

