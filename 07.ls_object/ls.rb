# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'file_info'
require_relative 'display_string'

class Ls
  def initialize(argv)
    @options = argv.getopts('a', 'r', 'l')
    entries = Dir.entries('.').sort
    unless @options['a']
      entries = entries.reject do |entry|
        entry[0] == '.'
      end
    end
    entries = entries.reverse if @options['r']

    @entries = entries.map do |entry_name|
      file_info = FileInfo.new(entry_name).extend(DisplayString)
      file_info.display_string = file_info.file_name

      file_info
    end
    @col_num = 3
  end

  def execute
    long_format if @options['l']

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

  private

  def long_format
    @col_num = 1
    puts "total #{@entries.map(&:block_num).sum}"
    max_lengths = find_max_length(%i[hardlink_num owner group file_size])
    @entries.each do |entry|
      entry.display_string = [entry.accessibility,
                              entry.hardlink_num.to_s.rjust(max_lengths[:hardlink_num]),
                              "#{entry.owner.rjust(max_lengths[:owner])} ",
                              "#{entry.group.rjust(max_lengths[:group])} ",
                              entry.file_size.to_s.rjust(max_lengths[:file_size]),
                              entry.datetime_str,
                              entry.file_name].join(' ')
    end
  end

  def find_max_length(keys)
    keys.map do |key|
      str_lengths = @entries.map do |entry|
        entry.public_send(key).to_s.length
      end
      [key, str_lengths.max]
    end.to_h
  end
end

ls = Ls.new(ARGV)
ls.execute
