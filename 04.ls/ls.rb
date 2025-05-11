# frozen_string_literal: true

require 'optparse'
require 'etc'

FILETYPES = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze
PERMISSION_CHARS = %w[r w x].freeze
class LS
  COL_NUM = 3

  def initialize(argv)
    @options = argv.getopts('a', 'r', 'l')
  end

  def execute
    entries = Dir.entries('.').sort!

    entries.reverse! if @options['r']

    unless @options['a']
      entries = entries.reject do |entry|
        entry[0] == '.'
      end
    end

    if @options['l']
      long_format(entries)
    else
      short_format(entries)
    end
  end

  def short_format(entries)
    total_lines = (entries.length.to_f / COL_NUM).ceil
    max_str_length = entries.map(&:length).max

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

  def long_format(entries)
    entry_info_list = entries.map do |entry|
      get_file_info(File.absolute_path(entry))
    end

    block_nums = entry_info_list.map { |h| h[:block_num] }
    puts "total #{block_nums.sum}"

    entry_info_list.each do |info|
      puts [info[:accessibility],
            info[:hardlink_num].to_s.rjust(get_max_length(entry_info_list, :hardlink_num)),
            "#{info[:owner].rjust(get_max_length(entry_info_list, :owner))} ",
            "#{info[:group].rjust(get_max_length(entry_info_list, :group))} ",
            info[:file_size].to_s.rjust(get_max_length(entry_info_list, :file_size)),
            info[:datetime_str],
            info[:file_name]].join(' ')
    end
  end

  def get_file_info(file_path_abs)
    { accessibility: get_accessibility(file_path_abs),
      hardlink_num: File.stat(file_path_abs).nlink,
      owner: Etc.getpwuid(File.stat(file_path_abs).uid).name,
      group: Etc.getgrgid(File.stat(file_path_abs).gid).name,
      file_size: File.stat(file_path_abs).size,
      datetime_str: File.stat(file_path_abs).mtime.strftime('%_m %e %H:%M'),
      file_name: File.basename(file_path_abs),
      block_num: File.stat(file_path_abs).blocks }
  end

  def get_max_length(hash_list, key)
    hash_list.map { |hash| hash[key].to_s.length }.max
  end

  def get_accessibility(entry)
    mode = File.stat(entry).mode.to_s(8).rjust(6, '0')
    file_type_oct = mode[0..1]
    file_mode_oct = mode[3..5]

    file_type = FILETYPES[file_type_oct]

    file_mode = file_mode_oct.chars.map do |num_char|
      number_permission_translator(num_char.to_i)
    end

    file_type + file_mode.join
  end

  def number_permission_translator(num)
    num_str = num.to_s(2).rjust(3, '0')
    permission_char_array = num_str.chars.map.with_index do |num_char, num_index|
      next '-' if num_char == '0'

      PERMISSION_CHARS[num_index]
    end

    permission_char_array.join
  end
end

ls = LS.new(ARGV)
ls.execute
