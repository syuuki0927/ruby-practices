# frozen_string_literal: true

require 'debug'

class LS
  ROW_NUM = 3
  def initialize
    # 引数関係の処理
  end

  def ls
    entries = Dir.entries('.').sort!

    # 非表示要素を除外
    entries = entries.reject do |entry|
      entry[0] == '.'
    end

    # 要素数が列数なら表示して終わり
    if entries.length <= ROW_NUM
      puts entries.join('    ')
    else
      show_multilines(entries)
    end
  end

  # 表示が複数行になるときに整形して表示
  def show_multilines(entries)
    # 合計で何行になるかを計算 (切り上げにすることで割り切れないエントリ数に対応)
    total_lines = (entries.length.to_f / ROW_NUM).ceil

    # 表示用の各行の要素を抽出
    show_lines = Array.new(total_lines).map.with_index do |_, line_i|
      entries.select.with_index do |_, entry_index|
        (entry_index % total_lines == line_i)
      end
    end

    # 各列の最大の要素の長さを調べる
    max_str_lengths = Array.new(ROW_NUM).map.with_index do |_, row_i|
      get_str_maxlength(show_lines.map do |line|
        line[row_i]
      end.compact) # 配列外参照のnil を削除
    end

    # 各列の最大の長さを使用して行を表示
    show_lines.each do |line|
      puts (line.map.with_index do |file_name, file_name_index|
        file_name.ljust(max_str_lengths[file_name_index])
      end).join('    ')
    end
  end

  # 表示する各列の最大の文字列の長さを返す
  def get_str_maxlength(str_array)
    str_array.map(&:length).max
  end
end

ls = LS.new
ls.ls
