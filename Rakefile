#
# http://mikeferrier.com/2011/04/29/blogging-with-jekyll-haml-sass-and-jammit/
#

# desc "Parse haml layouts"
# task :parse_haml do
#   print "Parsing Haml layouts..."
#   system(%{
#     cd _layouts/haml && 
#     for f in *.haml; do [ -e $f ] && haml $f ../${f%.haml}.html; done
#   })
#   puts "done."
# end

# rsync
PROD_DEST = 'nateware.com:vhosts/nateware.com'

desc "Launch preview environment"
task :preview do
  # Rake::Task["parse_haml"].invoke
  sh "bundle exec jekyll --auto --server"
end

desc "Build site"
task :build do |task, args|
  # Rake::Task["parse_haml"].invoke
  sh "bundle exec jekyll"
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
task :deploy do
  sh(%{
    rsync -avz --delete _site/ #{PROD_DEST}
  })
end
