# frozen_string_literal: true

class FileInfo
  FILETYPES = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze
  PERMISSION_CHARS = %w[r w x].freeze

  attr_reader :file_name

  def initialize(file_name)
    @file_name = file_name
  end

  def abs_path
    File.absolute_path(@file_name)
  end

  def hardlink_num
    File.stat(abs_path).nlink
  end

  def owner
    Etc.getpwuid(File.stat(abs_path).uid).name
  end

  def group
    Etc.getgrgid(File.stat(abs_path).gid).name
  end

  def file_size
    File.stat(abs_path).size
  end

  def datetime_str
    File.stat(abs_path).mtime.strftime('%_m %e %H:%M')
  end

  def block_num
    File.stat(abs_path).blocks
  end

  def accessibility
    mode = File.stat(abs_path).mode.to_s(8).rjust(6, '0')
    file_type_oct = mode[0..1]
    file_mode_oct = mode[3..5]

    file_type = FILETYPES[file_type_oct]

    file_mode = file_mode_oct.chars.map do |num_char|
      number_permission_translator(num_char.to_i)
    end

    file_type + file_mode.join
  end

  private

  def number_permission_translator(num)
    num_str = num.to_s(2).rjust(3, '0')
    permission_char_array = num_str.chars.map.with_index do |num_char, num_index|
      next '-' if num_char == '0'

      PERMISSION_CHARS[num_index]
    end

    permission_char_array.join
  end
end
