# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :score_marks, :frames

  def initialize(score_marks)
    self.score_marks = score_marks
  end

  def score_marks=(score_marks)
    @score_marks = score_marks.instance_of?(String) ? score_marks.split(',') : score_marks
    @frames = Frame.create_frames(@score_marks)
  end

  def score
    @frames.map(&:score).sum
  end
end
