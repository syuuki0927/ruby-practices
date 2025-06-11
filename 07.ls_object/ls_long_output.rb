# frozen_string_literal: true

require_relative 'file_properties'

class LsLongOutput
  def initialize(entries)
    @entries = entries.map do |entry|
      FileProperties.new(entry)
    end
  end

  def output
    puts "total #{@entries.map(&:block_num).sum}"
    max_lengths = find_max_length(%i[hardlink_num owner group file_size])
    @entries.each do |entry|
      output = [entry.accessibility,
                entry.hardlink_num.to_s.rjust(max_lengths[:hardlink_num]),
                "#{entry.owner.rjust(max_lengths[:owner])} ",
                "#{entry.group.rjust(max_lengths[:group])} ",
                entry.file_size.to_s.rjust(max_lengths[:file_size]),
                entry.datetime_str,
                entry.file_name].join(' ')
      puts output
    end
  end

  def find_max_length(keys)
    keys.map do |key|
      str_lengths = @entries.map do |entry|
        entry.public_send(key).to_s.length
      end
      [key, str_lengths.max]
    end.to_h
  end
end
