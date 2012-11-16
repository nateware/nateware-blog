# Adapted from https://gist.github.com/986665
# Grab the first paragraph of text and use it as the summary
# Can't just split on </p> or \r\n unfortunately because sometimes
# it's pre- and sometimes post- processing.
module Jekyll
  class Post
    alias_method :original_to_liquid, :to_liquid
    def to_liquid
      summary, body = content.split(%r(<!--\s*more\s*-->), 2)
      # catch for missing or dangling </p> on summary
      #summary.sub!(%r(\s*</p>\s*\Z), '')
      #summary += '</p>'

      # hurmph, compress HTML instead
      summary.gsub!(%r(</*p>),'')

      #puts "===\ncontent: #{content}\nsummary: #{summary}\n"
      original_to_liquid.deep_merge({
        'summary' => summary,
        'body'    => body
      })
    end
  end

  # Remove the summary in post pages... Liquid is really limited...
  module Filters
    def minus_summary(content)
      content.gsub(/.*<!--\s*more\s*-->/, '')
    end
    def strip_p(content)
      content.gsub(%r(</*p>),'')
    end
  end
end
