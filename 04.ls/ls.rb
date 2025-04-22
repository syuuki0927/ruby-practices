# frozen_string_literal: true

class LS
  COL_NUM = 3

  def execute
    entries = Dir.entries('.').sort!

    entries = entries.reject do |entry|
      entry[0] == '.'
    end

    if entries.length <= COL_NUM
      puts entries.join('    ')
    else
      show_multilines(entries)
    end
  end

  def show_multilines(entries)
    total_lines = (entries.length.to_f / COL_NUM).ceil

    show_lines = Array.new(total_lines).map.with_index do |_, line_i|
      entries.select.with_index do |_, entry_index|
        (entry_index % total_lines == line_i)
      end
    end

    max_str_lengths = Array.new(COL_NUM).map.with_index do |_, col_i|
      col_entries = show_lines.map do |line|
        line[col_i]
      end.compact

      get_colstr_maxlength(col_entries)
    end

    show_lines.each do |line|
      line_str = line.map.with_index do |file_name, col_i|
        file_name.ljust(max_str_lengths[col_i])
      end.join('    ')

      puts line_str
    end
  end

  # 表示する各列の最大の文字列の長さを返す
  def get_colstr_maxlength(str_array)
    str_array.map(&:length).max
  end
end

ls = LS.new
ls.execute
