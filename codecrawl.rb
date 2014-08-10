#codecrawl.rb crawls google for raw ruby code and uploads it to github
require 'net/http'

links = []
link_limit= 2
num_links = 0

uri = URI('http://www.google.com/search?q=require+OR+gem+OR+puts+-git+-bitbucket+-github+-rubygems.org+-metager.de+-html+filetype%3Arb&oq=require+OR+gem+OR+puts+-git+-bitbucket+-github+-rubygems.org+-metager.de+-html+filetype%3Arb&aqs=chrome..69i57.730j0j1&sourceid=chrome&es_sm=93&ie=UTF-8')
source = Net::HTTP.get(uri)

pages = ''
x=1
while num_links<=link_limit do
  source.gsub(/\/search.*?start=/){|f|
    pages = 'http://www.google.com' + f.gsub(/href="/,'')
    break
  }

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
  source = Net::HTTP.get(URI(pages+more_links))

  system 'git add --all'
  system 'git commit -a -m "found new ruby files"'
  system 'git pull origin master'
  system 'git push origin master'

end
