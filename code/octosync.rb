require 'time'
require 'simperium'
require 'logger'
require 'stringex'
require 'yaml'

LOGGER = Logger.new(STDOUT)

class Simplenote

  CURRENT_FNAME = File.expand_path(File.dirname __FILE__) + '/last_read_at.txt'
  SIMPERIUM_APP_ID = 'chalk-bump-f49' # = Simplenote
  SIMPERIUM_API_KEY = 'xxxxx' # email fred@simperium.com for your own key


  def initialize(simplenote_login, simplenote_pw)
    begin
      @auth = Simperium::Auth.new(SIMPERIUM_APP_ID, SIMPERIUM_API_KEY)
      @auth_token = @auth.authorize(simplenote_login, simplenote_pw)
      @notes = Simperium::Bucket.new(SIMPERIUM_APP_ID, @auth_token, 'note')
      @current = File.exists?(CURRENT_FNAME) ?  File.open(CURRENT_FNAME, "r") {|io| io.read} : nil
    rescue Exception => e
      abort e.message
    end
  end


# https://simperium.com/docs/reference/http/#apisummary
#
#  {
#    "index": [
#        {   "id": "item1", "v": 1 },
#        {   "id": "item2", "v": 3 },
#    ],
#    "current": "4f987082d240991a7e0200f6",
#    "mark": "324345fad0983450"
#  } ]

#  {
#     "v" : 9,
#     "id" : "agtzaW1wbGUtbmxIETm90ZRju844ODA",
#     "d" : {
#        "modificationDate" : 1361736443.51822,
#        "shareURL" : "",
#        "creationDate" : 1325021017.671,
#        "content" : "Home automation xxxxxx",
#        "publishURL" : "",
#        "deleted" : true,
#        "systemTags" : [],
#        "tags" : [
#           "x10",
#           "home_automation"
#        ]
#     }
#  }

  def posts(tag, &block)
    posts = {}

    LOGGER.info "Fetching SimpleNote posts with tag '#{tag}' ..."
    begin
      posts = @notes.index(data: 1, since: @current, mark: posts['mark'])
      if posts['index']
        LOGGER.info posts['index'].count
        posts['index'].map do |post|
          if post['d']['tags'].include?(tag) && !(post['d']['deleted'].eql?(true) || post['d']['deleted'] > 0)
            block.call(post['d'])
          end
        end
      end
    end while posts['mark']
    
    @new_current = posts['current']
  end


  def update_current
    if @new_current
      File.open(CURRENT_FNAME, 'w') { |file| file.write(@new_current) }
      @current = @new_current
    end
  end
end



class Octopresser

  def initialize(blog)
    abort("blogs[target] (#{blog[:target]}) is not a directory. Aborting") if ! File.directory?(File.expand_path blog[:target])
    @blog = blog
  end


  def title
    front_matter['title']
  end


  def filename
    t = Time.at(@post['modificationDate'])
    File.join(File.expand_path(@blog[:target]), t.strftime('%Y-%m-%d-') + title.to_url + '.markdown')
  end


  def front_matter
    @f_m ||= YAML.load(@post['content'])
    return (@f_m.instance_of?(Hash) && @f_m['title']) ? @f_m : nil
  end


  def save(post)
    @post = post
    @f_m = nil
    if front_matter
      LOGGER.info filename
      @f_m['date'] = Time.at(@post['modificationDate']).strftime('%Y-%m-%d %H:%M')
      @post['content'].sub!(/---\n(.*?)\n---\n/m, @f_m.to_yaml + "\n---\n")

      File.open(filename, 'w') { |file| file.write(@post['content']) }
    else
      LOGGER.warn "Post #{post['content']} does not have Jekyll front matter. Skipping it." 
    end
  end

end


class Octosync
  CONFIG = {
    simplenote_login: 'user',
    simplenote_pw: 'password',

    blogs: [
      {
        tag: 'blog',
        target: '~/octopress/source/_posts'
      }
    ]
  }

  def sync
    blog = CONFIG[:blogs][0]
    LOGGER.info("Syncing '#{CONFIG[:simplenote_login]}' SimpleNote account with '#{blog[:target]}' for tag '#{blog[:tag]}'")
    sleep(1)

    simplenote = Simplenote.new(CONFIG[:simplenote_login], CONFIG[:simplenote_pw])
    octopress = Octopresser.new(blog)

    simplenote.posts(blog[:tag]) do |post|
      octopress.save post
    end

    simplenote.update_current
  end
end

os = Octosync.new
os.sync
