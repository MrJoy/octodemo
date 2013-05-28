require 'pathname'
require 'active_support/all'

module Octodemo
  VERSION='0.0.1'
  OCTODEMO_ROOT=Pathname.new(File.dirname(__FILE__)) + '..'

  def self.root; return OCTODEMO_ROOT; end
end

$LOAD_PATH << Octodemo::OCTODEMO_ROOT + 'lib'
require 'octodemo/generator'
require 'octodemo/generator_dsl'
require 'octodemo/plugin'
require 'octodemo/rake'
