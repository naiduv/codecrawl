# tags.database.tml を texinfo 形式に変換する ruby スクリプト
# environ/win32/kag3docs_in/tag/to_html.pl から移植
#
# usage:
#   ruby -Ks to_texi.rb < tags.database.tml > kag-tag.texi


def taganalysis(data, tag)
  contents = []
  while data =~ Regexp.new("(<#{tag}[^>]+>)")
    taginfo = $1
    $' =~ Regexp.new("</#{tag}>")
    content = $`
    contents.push(taginfo + content)
    data = $'
  end
  contents
end

# extract text between tags
# eg. <foo>text</foo> => text
#
# delete '<ref tag=...>', '</ref>' and zenkaku-space
# substitute '<BR>' => "\n" and '@' => '@@'
def get_tag_text(data, tag)
  data =~ Regexp.new("<#{tag}>")
  $' =~ Regexp.new("</#{tag}>")
  $`
  if $`
    $`.gsub(/<ref\s+tag=["']([^"']+)["']>|<\/ref>|　/, '').gsub(/<BR>/, "\n").gsub(/@/){'@@'}
  end
end

text = $<.readlines.map{|line| line.strip}.join
tagdata = Hash.new()
taganalysis(text, 'tag').each{|tagcontent|
  tagcontent =~ /<tag name=['"]([^'"]+)['"]>/
  tagname = $1
  tagcontent = $'

  h = {}
  
  # get "shortinfo"
  h['shortinfo'] = get_tag_text(tagcontent, 'shortinfo')

  # get "group"
  h['group'] = get_tag_text(tagcontent, 'group')

  # get "remarks"
  h['remarks'] = get_tag_text(tagcontent, 'remarks')

  # get "example"
  example = get_tag_text(tagcontent, 'example')
  h['example'] = example if example

  # parse attrib
  if tagcontent =~ /<attribs>/
    $' =~ /<\/attribs>/
    no = 0
    attribs_data = []
    taganalysis($`, 'attrib').each{|attribcontent|

      # get "attrib's name"
      attribcontent =~ /<attrib name=['"]([^'"]+)['"]/
      attribnames = $1.split(',')

      # get "shortinfo"
      attr_shortinfo = get_tag_text(attribcontent, 'shortinfo')

      # get "required"
      attr_required = get_tag_text(attribcontent, 'required')
      
      # get "format"
      attr_format = get_tag_text(attribcontent, 'format')

      # get "info"
      attr_info = get_tag_text(attribcontent, 'info')
      
      attribnames.each{|name|
	attr_data = {}
	attr_data['name'] = name
	attr_data['shortinfo'] = attr_shortinfo
	attr_data['required'] = attr_required
	attr_data['format'] = attr_format
	attr_data['info'] = attr_info
	attribs_data << attr_data	
      }

    }

    h['attribs'] = attribs_data
  end

  
  tagdata[tagname] = h
}


puts DATA.readlines.join

tagdata.keys.sort.each{|tag_name|
  prop = tagdata[tag_name]
  puts '@deffn Tag ' + tag_name
  puts prop['remarks']

  if prop['example']
    puts ''
    puts '例:'
    puts '@example'
    puts prop['example']
    puts '@end example'
    puts ''
  end

  prop['attribs'].each{|attr|
    puts ''
    puts '@deffn Attribute' + (attr['required'] =~ /yes/ ? '* ' : ' ') + attr['name']
    puts '値: ' + attr['format']
    puts ''
    puts attr['info']
    puts '@end deffn'
  } if prop['attribs']
  
  puts '@end deffn'  
  puts ''
}


__END__
\input texinfo   @c -*-texinfo-*-
@c %**start of header
@setfilename kag-tag.info
@settitle KAG Tag Reference
@c %**end of header

@ifinfo
Copyright 2000-2005 W.Dee
@end ifinfo


@titlepage
@title KAG Tag Reference
@author W.Dee
@c  The following two commands
@c  start the copyright page.
@page
@vskip 0pt plus 1filll
Copyright @copyright{} 2000-2005 W.Dee
@end titlepage

@node Top, Tag Reference, , (dir)

@ifinfo 
これは KAG version 3.24 rev.2 用タグリファレンスです。
@end ifinfo

@menu
* Tag Reference::
@end menu
@node Tag Reference, , Top, Top
@chapter Tag Reference
