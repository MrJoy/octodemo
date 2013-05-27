require 'pathname'

module Octodemo
  VERSION='0.0.1'

  def self.init!
    $LOAD_PATH << Octodemo::OCTODEMO_ROOT

    require 'octodemo/rake'
  end

protected

  OCTODEMO_ROOT=Pathname.new(File.dirname(__FILE__)) + 'lib'
end
