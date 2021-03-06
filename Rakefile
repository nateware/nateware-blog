#
# http://mikeferrier.com/2011/04/29/blogging-with-jekyll-haml-sass-and-jammit/
#

require 'securerandom'

DEFAULT_FRONT_MATTER = <<EndMatter
---
layout: post
title: %s
disqus_identifier: #{SecureRandom.uuid}
draft: true
tags:
- webdesign
- programming
- databases
- gaming
- management
- blogging
- humor
- ruby
- rails
- sinatra
- redis
- mysql
- aws
- ec2
- s3
- redshift
- kinesis
- dynamodb
- beanstalk
---

<!--more-->
EndMatter

EDITOR = 'subl' # gvim

desc "Parse haml layouts"
task :parse_haml do
  print "Parsing Haml layouts..."
  Dir.chdir('_layouts') do
    sh(%{ for f in `ls *.haml`; do bundle exec haml $f ${f%.haml}.html; done })
  end
  puts "done."
end

desc "Launch preview environment"
task :preview do
  Rake::Task["parse_haml"].invoke
  sh "bundle exec jekyll serve --watch"
end

desc "Build site"
task :build do |task, args|
  # Rake::Task["parse_haml"].invoke
  sh "bundle exec jekyll build --lsi"
end

desc "Package app for production"
task :package do
  ENV['JEKYLL_ENV'] = 'production'
  Rake::Task["build"].invoke

  print "Compressing assets..."
  sh "bundle exec jammit -o assets -c _assets.yml"
  puts "done."
end

desc "Deploy latest code in _site to production"
task :deploy => :package do
  sh "bundle exec s3_website push"
end

desc "Create a new post and start editing it"
task :post do
  unless ENV['TITLE']
    abort "Usage: rake post TITLE='Title of New Post'"
  end

  title = ENV['TITLE']
  slug  = title.downcase.gsub(/\s+/, '-').gsub(/[^-a-z0-9]+/, '')
  date  = Time.now.strftime('%Y-%m-%d')
  file  = File.dirname(__FILE__) + "/_posts/#{date}-#{slug}.md"

  if File.exists? file
    abort "Error: Post already exists: #{file}"
  end

  File.open(file, 'w') do |f|
    f << sprintf(DEFAULT_FRONT_MATTER, title)
  end
  puts "Wrote #{file}"
  sh "#{EDITOR} #{file}"
end
