# frozen_string_literal: true

require 'optparse'
require_relative 'ls_long_output'
require_relative 'ls_short_output'

class Ls
  def initialize(argv)
    @options = {}
    @option_parser = OptionParser.new
    @option_parser.on('-a') { |v| @options[:a] = v }
    @option_parser.on('-r') { |v| @options[:r] = v }
    @option_parser.on('-l') { |v| @options[:l] = v }
    @option_parser.parse(argv)

    @entries = Dir.entries('.').sort
    unless @options[:a]
      @entries = @entries.reject do |entry|
        entry[0] == '.'
      end
    end
    @entries = @entries.reverse if @options[:r]
  end

  def execute
    if @options[:l]
      LsLongOutput.new(@entries).output
    else
      LsShortOutput.new(@entries).output
    end
  end
end
