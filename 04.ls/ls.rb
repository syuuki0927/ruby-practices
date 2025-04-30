# frozen_string_literal: true

require 'optparse'

class LS
  COL_NUM = 3

  def initialize(argv)
    @options = argv.getopts('a', 'r')
  end

  def execute
    entries = Dir.entries('.').sort!

    entries.reverse! if @options['r']

    unless @options['a']
      entries = entries.reject do |entry|
        entry[0] == '.'
      end
    end

    if entries.length <= COL_NUM
      puts entries.join(' ')
    else
      show_multilines(entries)
    end
  end

  def show_multilines(entries)
    total_lines = (entries.length.to_f / COL_NUM).ceil
    max_str_length = get_maxstr_length(entries)

    show_lines = Array.new(total_lines).map.with_index do |_, line_i|
      entries.select.with_index do |_, entry_index|
        (entry_index % total_lines == line_i)
      end
    end

    show_lines.each do |line|
      line_str = line.map do |file_name|
        file_name.ljust(max_str_length + 1)
      end.join

      puts line_str
    end
  end

  def get_maxstr_length(str_array)
    str_array.map(&:length).max
  end
end

ls = LS.new(ARGV)
ls.execute
