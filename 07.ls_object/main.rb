# frozen_string_literal: true

require_relative 'ls'

ls = Ls.new(ARGV)
ls.execute
