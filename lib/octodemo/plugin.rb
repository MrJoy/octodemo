module Octodemo
  class Plugin
    def self.inherited(subclass)
      @plugins ||= []
      @plugins << subclass
      puts "Registering Plugin: #{subclass}"
    end

    def self.init!(ctx)
      init_generators!
      init_rake!(ctx)
    end

    def self.init_generators!
      @generators ||= {}
      ctx = GeneratorsDSL.new(Octodemo)
      ctx.instance_eval(File.read(Octodemo::OCTODEMO_ROOT + 'lib' + 'octodemo' + 'generators.rb'))
      @generators.merge!(ctx.to_generators)

      @plugins.each do |plugin|
        ctx = GeneratorsDSL.new(plugin)
        plugin_generators = File.join(plugin.root, 'lib', plugin.name, 'generators.rb')
        if(File.exist?(plugin_generators))
          ctx.instance_eval(File.read(plugin_generators))
        end
        @generators.merge!(ctx.to_generators)
      end
    end

    def self.init_rake!(ctx)
      @plugins.each do |plugin|
        plugin_tasks = File.join(plugin.root, 'lib', plugin.name, 'tasks.rake')
        if(File.exist?(plugin_tasks))
          ctx.instance_eval do
            load plugin_tasks
          end
        end
      end

      if(@generators.keys.count > 0)
        @generators.each do |name, generator|
          ctx.instance_eval do
            namespace :new do
              desc generator.description
              task name do
                generator.run("./source", ENV)
              end
            end
          end
        end
      end
    end

  private

    def self.root; return self.const_get(:ROOT); end
    def self.name; return self.to_s.underscore; end
  end
end
