# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(first_mark, second_mark, third_mark = nil)
    marks = [first_mark, second_mark, third_mark]
    @shots = marks.map { |mark| Shot.new(mark) }
  end

  def score
    shot_scores = @shots.map(&:score)
    if shot_scores[0..1].sum >= 10
      shot_scores.sum
    else
      shot_scores[0..1].sum
    end
  end

  def strike?
    @shots[0].score == 10
  end

  def spare?
    @shots[0..1].sum == 10
  end

  def shot_num
    strike? ? 1 : 2
  end

  def self.create_frames(scores_str)
    frames = []
    throw_cnt = 0
    while frames.length < 10 && throw_cnt < scores_str.length
      frames << Frame.new(*scores_str[throw_cnt..throw_cnt + 2])
      throw_cnt += frames[-1].shot_num
    end

    frames
  end
end
