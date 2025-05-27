# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize(first_mark, second_mark = 0, third_mark = nil)
    @shots = [first_mark, second_mark, third_mark].map { |mark| Shot.new(mark) }

    # strike?, spare?は@shots[0..1]に依存
    if strike?
      @bonus = @shots[1..2].map(&:score).sum
      @shots = [@shots[0]]
    else
      @bonus = spare? ? @shots[2].score : 0
      @shots = @shots[0..1]
    end
  end

  def score
    @shots.map(&:score).sum + @bonus
  end

  def strike?
    @shots[0].score == 10
  end

  def spare?
    !strike? && @shots[0..1].map(&:score).sum == 10
  end
end
