# Image tag with optional caption.
# See: http://www.w3.org/Style/Examples/007/figures.en.html
class ImageTag < Liquid::Tag
  def initialize(tag_name, name, tokens)
    super tag_name, name, tokens
    @path = '/images'
  end

  def render(context)
    return "ImageTag: #{tag_name.inspect}, #{name.inspect}, #{tokens.inspect}"

    #%Q(<div class="figure"<img src="#{name}"
        #alt="#{title}"><p>#{caption}</p></div>)
  end
end

Liquid::Template.register_tag('image_tag', ImageTag)
