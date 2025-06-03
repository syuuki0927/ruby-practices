# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'file_info'
require_relative 'display_string'

class Ls
  def initialize(argv)
    @options = {}
    @option_parser ||= OptionParser.new
    @option_parser.on('-a') { |v| @options[:a] = v }
    @option_parser.on('-r') { |v| @options[:r] = v }

    @option_parser.parse(argv)

    entries = Dir.entries('.').sort
    unless @options[:a]
      entries = entries.reject do |entry|
        entry[0] == '.'
      end
    end

    entries = entries.reverse if @options[:r]

    @entries = entries.map do |entry_name|
      file_info = FileInfo.new(entry_name).extend(DisplayString)
      file_info.display_string = file_info.file_name

      file_info
    end
    @col_num = 3
  end

  def execute
    total_lines = (@entries.length.to_f / @col_num).ceil
    max_str_length = @entries.map do |entry|
      entry.display_string.length
    end.max

    show_lines = Array.new(total_lines).map.with_index do |_, line_i|
      @entries.select.with_index do |_, entry_index|
        entry_index % total_lines == line_i
      end
    end

    show_lines.each do |line|
      line_str = line.map do |line_entry|
        line_entry.display_string.ljust(max_str_length + 1)
      end.join

      puts line_str
    end
  end
end
