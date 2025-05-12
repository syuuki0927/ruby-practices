# frozen_string_literal: true

require 'optparse'

OPTION_SYMS = %i[l w c].freeze

def main
  options, file_paths = collect_options

  input_records = file_paths.map do |input_file|
    lines = File.open(input_file, 'r', &:readlines)
    { lines: lines, name: input_file }
  end

  input_records << { lines: readlines, name: '' } if input_records.length <= 0

  counted_records = input_records.map do |record|
    line_num = options['l'] ? line_count(record) : 0
    word_num = options['w'] ? word_count(record) : 0
    byte_num = options['c'] ? byte_count(record) : 0

    { l: line_num, w: word_num, c: byte_num, file_name: record[:name] }
  end

  print_counted(counted_records, options)
end

def collect_options
  options = ARGV.getopts(*OPTION_SYMS.map(&:to_s))
  options.keys.each { |k| options[k] = true } if options.values.none?

  opt_parser = OptionParser.new
  OPTION_SYMS.each do |opt_sym|
    opt_parser.on("-#{opt_sym}")
  end
  file_paths = opt_parser.parse(ARGV)

  [options, file_paths]
end

# @param record_hash {lines:, name:}
def line_count(record_hash)
  record_hash[:lines].length
end

# @param record_hash {lines:, name:}
def word_count(record_hash)
  record_hash[:lines].join.split.length
end

# @param record_hash {lines:, name:}
def byte_count(record_hash)
  record_hash[:lines].join.bytesize
end

def print_counted(counted_records, options)
  if counted_records.length >= 2
    total = OPTION_SYMS.map do |opt|
      [opt, hash_list_sum(counted_records, opt)]
    end
    total << [:file_name, 'total']

    counted_records << total.to_h
  end

  counted_records.each do |record|
    OPTION_SYMS.each do |opt|
      print " #{record[opt].to_s.rjust(7)}" if options[opt.to_s]
    end

    puts " #{record[:file_name]}"
  end
end

def hash_list_sum(hash_list, key)
  hash_list.map { |h| h[key] }.sum
end

main
