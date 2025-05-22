# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :score_marks, :frames

  def initialize(score_marks = '')
    self.score_marks = score_marks
  end

  def score_marks=(score_marks)
    @score_marks = score_marks.instance_of?(String) ? score_marks.split(',') : score_marks
    @frames = create_frames
  end

  def score
    @frames.map(&:score).sum
  end

  private

  def create_frames
    frames = []
    throw_cnt = 0
    while frames.length < 10 && throw_cnt < @score_marks.length
      frames << Frame.new(*@score_marks[throw_cnt..throw_cnt + 2])
      throw_cnt += frames[-1].shots.length
    end

    frames
  end
end
