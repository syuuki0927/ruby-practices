# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(score_marks = '')
    @frames = create_frames(score_marks.split(','))
  end

  def score
    @frames.map(&:score).sum
  end

  private

  def create_frames(score_marks)
    frames = []
    throw_cnt = 0
    while frames.length < 10
      frames << Frame.new(*score_marks[throw_cnt..throw_cnt + 2])
      throw_cnt += frames[-1].shots.length
    end

    frames
  end
end
