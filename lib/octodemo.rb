require 'pathname'

module Octodemo
  VERSION='0.0.1'
  OCTODEMO_ROOT=Pathname.new(File.dirname(__FILE__))
end

$LOAD_PATH << Octodemo::OCTODEMO_ROOT
require 'octodemo/plugin'
require 'octodemo/rake'
