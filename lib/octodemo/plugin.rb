module Octodemo
  class Plugin
    def self.inherited(subclass)
      @plugins ||= []
      @plugins << subclass
      puts "New subclass: #{subclass}"
    end
  end
end
