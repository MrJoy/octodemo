module Octodemo
  class Plugin
    def self.inherited(subclass)
      @plugins ||= []
      @plugins << subclass
      puts "New subclass: #{subclass}"
    end

    def self.init_rake!(ctx)
      @plugins.each do |plugin|
        next unless(plugin.respond_to?(:init_rake!))
        ctx.instance_eval do
          namespace :plugins do
            namespace plugin.to_s.underscore.to_sym do
              plugin.init_rake!(ctx)
            end
          end
        end
      end
    end
  end
end
