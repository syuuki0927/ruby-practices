# frozen_string_literal: true

require 'optparse'

require_relative 'ls'

class LsLong < Ls
  def initialize(argv)
    @option_parser = OptionParser.new
    @option_parser.on('-l') { |v| @options[:l] = v }
    super
  end

  def execute
    long_format if @options[:l]
    super
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
