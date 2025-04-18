#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'

options = ARGV.getopts('m:', 'y:')

today = Date.today

m = options['m']
y = options['y']

if m.nil? && y
  raise ArgumentError, '-yのみの指定は無効です'
elsif !m.nil? && y.nil?
  y = today.year
  m = m.to_i
elsif !m.nil? && !y.nil?
  y = y.to_i
  m = m.to_i
else
  y = today.year
  m = today.month
end

# 1週間の日付部分の長さを使用して月、年を中央配置（01は日付に相当）
puts "#{m}月 #{y}".center(Array.new(7) { '01' }.join(' ').length)
puts '日 月 火 水 木 金 土'

first_day = Date.new(y, m, 1)

#  最初の行 1日の曜日までスペース
week_days = Array.new(first_day.wday) { '  ' }

(first_day..(first_day.next_month - 1)).each do |current_day|
  week_days << current_day.day.to_s.rjust(2)
  if week_days.length >= 7
    puts week_days.join(' ')
    week_days = []
  end
end

puts week_days.join(' ') unless week_days.empty?
