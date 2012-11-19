# Image tag with optional caption.
# See: http://www.w3.org/Style/Examples/007/figures.en.html
class ImageTag < Liquid::Tag
  PATH = '/images'

  # This handles parsing all args other than the first one.
  # So image_tag('myimage.png', :a => 'b', :c => 'd') yields
  # the string ":a => 'b', :c => 'd'" to this.
  def parse(markup)


  end

  def render(context)
    %Q(<div class="figure"<img src="#{name}"
        alt="#{title}"><p>#{caption}</p></div>)
  end
end

Liquid::Template.register_tag('image_tag', ImageTag)

