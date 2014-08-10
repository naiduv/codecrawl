#codecrawl.rb crawls google for raw ruby code and uploads it to github
require 'net/http'

def push_to_git
  system 'git add --all'
  system 'git commit -a -m "found new ruby files"'
  system 'git pull origin master'
  system 'git push origin master'
end

link_limit= 80000
num_links = 0

uri = URI('http://www.google.com/search?q=require+OR+gem+OR+puts+-git+-bitbucket+-github+-rubygems.org+-metager.de+-html+filetype%3Arb&safe=active')
source = Net::HTTP.get(uri)

pages = ''


x=1
while num_links<=link_limit do
  
  links = []
  
  lastpages = uri.to_s

  source.gsub(/\/search.*?start=/){|f|
    pages = 'http://www.google.com' + f.gsub(/href="/,'')
    if (pages.length/lastpages.length)==1
      break
    end
  }
  pages = pages.gsub(/amp;/, '')
  lastpages = pages

  source.gsub(/href="\/url\?q=.*?">/) {|f|
    if(f.include? 'webcache') || (f.include? 'https')
         next
    end

    links.push(f.gsub(/href="\/url\?q=/, '').gsub(/\.rb.*$/, '')+'.rb')
    num_links+=1
  }

  links.each do |link|
    code = Net::HTTP.get(URI(link))
    filename = './code' + link.match('\/[^/]*$')[0]
    puts filename
    File.open(filename, 'w') {|f| f.write(code) }

  end

  x+=1
  more_links = (x*10).to_s

  puts "\n\n" + pages+more_links

  source = Net::HTTP.get(URI(pages+more_links))


  push_to_git
end
