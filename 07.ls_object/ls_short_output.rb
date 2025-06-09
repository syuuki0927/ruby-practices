# frozen_string_literal: true

class LsShortOutput
  COL_NUM = 3

  def initialize(entries)
    @entries = entries
  end

  def output
    total_lines = (@entries.length.to_f / COL_NUM).ceil
    max_str_length = @entries.map(&:length).max

    show_lines = Array.new(total_lines).map.with_index do |_, line_i|
      @entries.select.with_index do |_, entry_index|
        entry_index % total_lines == line_i
      end
    end

    show_lines.each do |line|
      line_str = line.map do |line_entry|
        line_entry.ljust(max_str_length + 1)
      end.join

      puts line_str
    end
  end
end
