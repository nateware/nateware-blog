# Image tag with optional caption.
# See: http://www.w3.org/Style/Examples/007/figures.en.html
class ImageTag < Liquid::Tag
  PATH = '/images'
  attr_reader :name

  def initialize(tag_name, splat, tokens)
    super
    parse_args(splat)
  end

  # This handles parsing all args other than the first one.
  # So image_tag('myimage.png', :a => 'b', :c => 'd') yields
  # the string ":a => 'b', :c => 'd'" to this.
  def parse_args(splat)
    @atts = nil
    @opts = {}

    # strip any trailing hash-like thingy (Ruby 1.8 style)
    if splat.sub!(/\s+:([a-z]\w+\s*=>.*)/,'')
      $1.to_s.split(/\s*,\s*/).each do |r|
        k, v = r.split(/\s*=>\s*/)
        @opts[k.sub(/^:/,'')] = strip_quotes(v)
      end
    end

    @args = splat.split(/\s*,\s*/).map{|x| strip_quotes(x) }
    @image = @args.shift
    @caption = @args.shift
    @tooltip = @args.shift || @caption
  end

  def strip_quotes(x)
    x.gsub(/^\s*['"]|['"]\s*$/,'')
  end

  def opts_to_html
    @opts.reject{|k,v| k == 'class'}.collect{|k,v| %Q(#{k}="#{v}")}.join(' ')
  end

  def render(context)
    %Q(<div class="figure #{@opts['class']}"><img src="#{PATH}/#{@image}") +
    %Q( alt="#{@caption}" title="#{@caption}" #{opts_to_html} />)+
    %Q(<p class="caption">#{@caption}</p></div>)
  end
end

Liquid::Template.register_tag('image_tag', ImageTag)

