# frozen_string_literal: true

require_relative 'ls_long'

ls = LsLong.new(ARGV)
ls.execute
