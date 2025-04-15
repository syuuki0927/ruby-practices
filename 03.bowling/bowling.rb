#!/usr/bin/env ruby
# frozen_string_literal: true

# 引数確認
raise ArgumentError, 'スコアを入力してください' unless ARGV.length >= 1

# 投球ごとのスコアの配列を作成。ストライク（X）は10に
scores = ARGV[0].split(',').map do |score_str|
  if score_str == 'X'
    10
  else
    score_str.to_i
  end
end
p scores

# 必要に応じて（ストライクやスペア）後の投球のスコアを参照し、フレームごとの得点を計算していく
frame_scores = []
now_i = 0
while frame_scores.length < 10
  if scores[now_i] == 10
    frame_scores << scores[now_i..now_i + 2].sum
    now_i += 1
  elsif scores[now_i] + scores[now_i + 1] >= 10
    frame_scores << scores[now_i..now_i + 2].sum
    now_i += 2
  else
    frame_scores << scores[now_i..now_i + 1].sum
    now_i += 2
  end
end

# 全てのフレームの合計点
puts frame_scores.sum
