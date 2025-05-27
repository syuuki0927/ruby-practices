#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

abort('スコアを入力してください') if ARGV.empty?

game = Game.new(ARGV[0])
puts game.score
