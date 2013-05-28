module Octodemo
  module Rake
    def self.init!(ctx)
      ctx.instance_eval do
        load Octodemo::OCTODEMO_ROOT + 'lib' + 'octodemo' + 'project_tasks.rake'
      end

      Octodemo::Plugin.init!(ctx)
    end
  end
end
