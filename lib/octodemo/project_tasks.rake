require 'rake/clean'
CLEAN.include('public')
CLOBBER.include('deploy')

desc "Build the site."
task :build do
  puts "Do something here..."
end
