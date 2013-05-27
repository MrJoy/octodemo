module Octodemo
  module Rake
    def self.init!(ctx)
      ctx.instance_eval do
        load Octodemo::OCTODEMO_ROOT + 'octodemo' + 'project_tasks.rake'
      end

      Octodemo::Plugin.init_rake!(ctx)
    end
  end
end
