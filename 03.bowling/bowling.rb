#!/usr/bin/env ruby
# frozen_string_literal: true

if ARGV.empty?
  warn('スコアを入力してください')
  exit false
end

scores = ARGV[0].split(',').map do |score_str|
  if score_str == 'X'
    10
  else
    score_str.to_i
  end
end

frame_scores = []
throw_cnt = 0
while frame_scores.length < 10
  if scores[throw_cnt] == 10
    frame_scores << scores[throw_cnt..throw_cnt + 2].sum
    throw_cnt += 1
  elsif scores[throw_cnt] + scores[throw_cnt + 1] >= 10
    frame_scores << scores[throw_cnt..throw_cnt + 2].sum
    throw_cnt += 2
  else
    frame_scores << scores[throw_cnt..throw_cnt + 1].sum
    throw_cnt += 2
  end
end

puts frame_scores.sum
