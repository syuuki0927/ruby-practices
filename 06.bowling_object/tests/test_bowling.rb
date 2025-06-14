# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../game'

class GameTest < Minitest::Test
  def test_game
    assert_equal 139, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5').score
    assert_equal 164, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X').score
    assert_equal 107, Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4').score
    assert_equal 134, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0').score
    assert_equal 144, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8').score
    assert_equal 300, Game.new('X,X,X,X,X,X,X,X,X,X,X,X').score
    assert_equal 292, Game.new('X,X,X,X,X,X,X,X,X,X,X,2').score
    assert_equal 50, Game.new('X,0,0,X,0,0,X,0,0,X,0,0,X,0,0').score
  end
end
