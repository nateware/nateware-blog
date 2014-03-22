# Adapted from https://gist.github.com/986665
#
# Grab the section before <!--more--> of text and use it as the summary
# Can't just split on </p> or \r\n unfortunately because sometimes
# it's pre- and sometimes post- processing in Liquid (boo).
#
module Jekyll
  # class Post
  #   alias_method :original_to_liquid, :to_liquid
  #   def to_liquid(attrs = ATTRIBUTES_FOR_LIQUID)
  #     summary, body = content.split(/\s*<!--\s*more\s*-->\s*/, 2)

  #     # remove any paragraph tags from summary
  #     summary.gsub!(%r(</*p>),'')

  #     #puts "===debug===\ncontent: #{content}\nsummary: #{summary}\n"
  #     puts "summary=#{summary.inspect}"
  #     puts "#{extracted_excerpt}"
  #     raise "#{methods.sort}"
  #     original_to_liquid(attrs).deep_merge({
  #       'summary' => summary,
  #       'body'    => body
  #     })
  #   end
  # end

  # Remove the summary in post pages... Liquid has some quirks.
  # Use like: {{content | minus_summary}}
  module Filters
    def minus_summary(content)
      content.gsub(/.*<!--\s*more\s*-->/m, '')
    end
    def strip_p(content)
      content.gsub(%r(</*p>),'')
    end
  end
end
