#!/usr/local/bin/ruby -w
INDENT = 2 # spaces
class CType
  def initialize(string)
    @string = string
  end

  # for pointer types, we don't want a space after the *.
  def to_s
    @string + ((@string =~ /\*$/) ? "" : " ")
  end

end

class String

  # To DRY out indentation.
  def indent(indentlevel = 1)
    spaces = " " * (INDENT * indentlevel)
    self.gsub(/^/m, spaces)
  end

  # To DRY out indentation.
  def indent!(indentlevel = 1)
    spaces = " " * (INDENT * indentlevel)
    self.gsub!(/^/m, spaces)
  end

end

class CClassCreator

  # Setup class classname, with the comment purpose, depending on
  # dependents, and attributes passed in the hash h.
  # If a block is given it is passed to instance_eval, so that
  # the methods can be created in the correct context.
  def initialize(classname, purpose, dependents, headers, h, &block)
    @classname = classname
    @classdown = @classname.downcase
    @cfilename = @classdown + ".c"
    @hfilename = @classdown + ".h"
    @hconstant = (@classname+"_H").upcase
    @purpose = %Q£/*\n#{purpose.gsub(/^/m, " * ")}\n */£;
    raise "We need a classname beginning with an upper case character" if @classdown == @classname;
    @dependents = dependents
    @headers = headers
    @attributes = h
    open(@hfilename, "w") do |hfp|
      @hfp = hfp
      @hfp.puts <<-CSTRING
#ifndef #{@hconstant}
#define #{@hconstant} 1
      CSTRING
      open(@cfilename, "w") do |cfp|
        @cfp = cfp
        instance_eval { create_class; create_accessors;}
        instance_eval(&block) if block_given?
      end
      @hfp.puts <<-CSTRING
#endif
      CSTRING
    end
  end

  # Create the C infrastructure for the class.
  # This involves adding the #include statemens to the .h file,
  # creating the function to construct it, including an appropriate
  # malloc call. 
  def create_class()
    @headers.each do |name|
      @hfp.puts <<-CSTRING
#include <#{name.downcase}.h>
      CSTRING
    end
    @dependents.each do |name|
      @hfp.puts <<-CSTRING
#include "#{name.downcase}.h"
      CSTRING
    end
    create_struct_def

    @cfp.puts <<-CSTRING
#include "#{@hfilename}"
    CSTRING

    # Create the constructors
    str = <<-CSTRING
/* Constructor for class #{@classname} */
#{@classname} *#{@classdown}_create(
    CSTRING
    attribs = []
    @attributes.each_pair do |name,type|
      type = CType.new(type)
      attribs << ("#{type}#{name}".indent)
    end
    list = attribs.join(",\n");
    str += "#{list})"
    fsig str
    @cfp.puts <<-CSTRING
{
  #{@classname} *#{@classdown};
    CSTRING
    @cfp.puts malloc_block(@classdown, "#{@classname}")
    @attributes.each_pair do |name,type|
      @cfp.puts <<-CSTRING
  #{@classdown}->#{name} = #{name};
      CSTRING
    end
    @cfp.puts <<-CSTRING
  return(#{@classdown});
    CSTRING
    @cfp.puts "}\n"
    str = <<-CSTRING

/* Empty Constructor for class #{@classname} */
#{@classname} *#{@classdown}_create_empty()
    CSTRING
    fsig str
    @cfp.puts <<-CSTRING
{
  #{@classname} *#{@classdown};
    CSTRING
    @cfp.puts malloc_block(@classdown, "#{@classname}")
    @cfp.puts <<-CSTRING
  return(#{@classdown});
};

    CSTRING
    hc
  end

  # Create the accessors.  We may not wish to use them, because
  # generally one doesn't fiddle with the internals of an object, 
  # but it is is simpler to create them and not use them than 
  # fiddle about working out which ones we want to have access to,
  # in what way, etc.  I'm writing this code for my own use, so
  # hopefully I can trust my older self to be a little wiser.
  # We'll take the philosophical rant about Hughman stupidy as read.
  def create_accessors
    hc 
    @attributes.each_pair do |name,type|
      type = CType.new(type)
      str = <<-CSTRING
void #{@classdown}_set_#{name}(#{@classname} *self, #{type}#{name})
      CSTRING
      @hfp.puts "#{str.chomp};"
      @cfp.puts "#{str}"
      @cfp.puts <<-CSTRING
{
  self->#{name} = #{name};
}

      CSTRING
      str = <<-CSTRING

#{type}#{@classdown}_get_#{name}(#{@classname} *self)
      CSTRING
      @hfp.puts "#{str.chomp};"
      @cfp.puts "#{str}"
      @cfp.puts <<-CSTRING
{
  return(self->#{name});
}
      CSTRING
    end
    hc
  end

  # fsig() provides a function signature, into the header
  # as a prototype (terminated with a ';') and into  the code
  # so that the function body will follow.
  def fsig(str)
    @hfp.puts "#{str.chomp};"
    @cfp.puts "#{str}"
  end

  # To reduce repetition, hc puts its argument out to both the
  # header and the C file.
  def hc(*args)
    @hfp.puts(*args)
    @cfp.puts(*args)
  end
  

  # Create structure definition.
  def create_struct_def
    @hfp.puts
    @hfp.puts @purpose
    @hfp.puts %Q(struct #{@classname} {)
    @attributes.each_pair do |name,type|
      type = CType.new(type)
      @hfp.puts "  #{type}#{name};"
    end
    @hfp.puts <<-CSTRING
};

typedef struct #{@classname} #{@classname};

    CSTRING
  end

  def malloc_block(ptr, type, howmany = 1, indentlevel = 1)
    str  = <<-CSTRING 
#{ptr} = (#{type}*)malloc(sizeof(#{type}) #{((howmany == 1) ? "" : " * #{howmany}")});
if (#{ptr} == NULL)
{
  fprintf(stderr, "Unable to allocate space for #{howmany} #{type}#{((howmany == 1) ? '' : 's')}");
  exit(-1);
}
    CSTRING
    str.indent!
    return str
  end


  # Given these three strings, create the method with definitions
  # in the appropriate files.
  def create_method(comment, signature, body)
    @cfp.puts
    @cfp.puts comment
    fsig(signature)
    @cfp.puts body
    hc
  end
end

