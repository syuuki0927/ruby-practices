#!/usr/bin/env ruby

require 'optparse'
require 'date'

params = ARGV.getopts("m:", "y:")

date = Date.today

m = params["m"]
y = params["y"]

# 引数から表示する月を取得
if m.nil? && y
    # 年のみの指定は実装しない
    raise ArgumentError.new("-yのみの指定は無効です")
elsif !m.nil? && y.nil?
    # 月のみの指定
    y = date.year
    m = m.to_i
elsif !(m.nil?) && !(y.nil?)
    # 月、日どちらも指定
    y = y.to_i
    m = m.to_i
else
    # 指定なし。今月を出力
    y = date.year
    m = date.month
end

# 表示する月、年を中央でプリント
puts "#{m}月 #{y}".center(Array.new(7){"  "}.join(" ").length, " ")
puts "日 月 火 水 木 金 土"

date = Date.new(y, m, 1)

#  最初の行
# 1日の分までスペース
week_days = Array.new(date.wday) { "  " }

# 日付でWhile
# 同月中
while date.month == m
    week_days << date.day.to_s.rjust(2, " ")
    # puts week_days.length
    if week_days.length >= 7
        puts week_days.join(" ")
        week_days = []
    end
    date = date.next_day
end

# 残りを出力
puts week_days.join(" ") unless week_days.empty?
