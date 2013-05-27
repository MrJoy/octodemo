# -*- encoding: utf-8 -*-

Gem::Specification.new do |octo|
  octo.specification_version = 2 if octo.respond_to? :specification_version=
  octo.required_rubygems_version = Gem::Requirement.new(">= 0") if octo.respond_to? :required_rubygems_version=
  octo.rubygems_version = '1.3.5'

  octo.name          = 'octodemo'
  octo.version       = '0.0.1'
  octo.date          = '2013-05-26'
  octo.authors       = ['Jon Frisby']
  octo.email         = %w[jfrisby@mrjoy.com]
  octo.description   = %q{Demonstration of how to handle git-based plugins.}
  octo.summary       = %q{Demonstration of how to handle git-based plugins.}
  octo.homepage      = "http://octopress.org"

  octo.rdoc_options = ["--charset=UTF-8"]
  octo.extra_rdoc_files = %w[README.md]

  # = MANIFEST =
  octo.files = %w[
    README.md
    Rakefile
    lib/octodemo.rb
    lib/octodemo/project_tasks.rake
    lib/octodemo/rake.rb
    octodemo.gemspec
  ]
  # = MANIFEST =

  octo.require_paths = %w[lib]
  octo.executables   = octo.files.grep(%r{^bin/}).map{ |f| File.basename(f) }

  # {
  #   'rack' => '~> 1.5.0',
  #   'jekyll' => '~> 1.0.2',
  #   'redcarpet' => '~> 2.2.2',
  #   'RedCloth' => '~> 4.2.9',
  #   'haml' => '~> 3.1.7',
  #   'compass' => '~> 0.12.2',
  #   'sass-globbing' => '~> 1.0.0',
  #   'rubypants' => '~> 0.2.0',
  #   'stringex' => '~> 1.4.0',
  #   'liquid' => '~> 2.3.0',
  #   'tzinfo' => '~> 0.3.35',
  #   'json' => '~> 1.7.7',
  #   'sinatra' => '~> 1.4.2',
  #   'stitch-rb' => '~> 0.0.8',
  #   'uglifier' => '~> 2.1.0',
  #   'guard' => '~> 1.8.0',
  #   'guard-shell' => '~> 0.5.1',
  #   'guard-compass' => '~> 0.0.6',
  #   'guard-coffeescript' => '~> 1.3.0',
  #   'rb-inotify' => '~> 0.9.0',
  #   'rb-fsevent' => '~> 0.9.3',
  #   'rb-fchange' => '~> 0.0.6',
  # }.each do |gem_name, version|
  #   octo.add_runtime_dependency(gem_name, version)
  # end

  octo.add_development_dependency('rake', '~> 10.0.4')
end
