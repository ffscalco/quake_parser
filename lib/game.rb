#!/usr/bin/env ruby
require './lib/means_death.rb'

class Game
  attr_accessor :total_kills, :players, :name, :kills_by_means

  def initialize(name)
    @name = name
    @total_kills = 0
    @players = []
    @kills_by_means =[]
  end

  def find_player(line, type, name=nil)
    player = self.players.select{|p| p.name == name}.first unless name.nil?

    if player.nil?
      player = self.players.select{|p| p.id == get_id(line, type) and p.online?}.first
    else
      player.id = get_id(line, type)
      player.online = true
    end

    return player
  end

  def count_kills_by_means(translate)
    if translate
      meanings = self.kills_by_means.inject(Hash.new(0)) { |total, means| total[MeansDeath.const_get(means)] += 1 ;total}
    else
      meanings = self.kills_by_means.inject(Hash.new(0)) { |total, means| total[means] += 1 ;total}
    end

    return meanings.sort_by { |key, value| -value }.to_h
  end

  private
    def get_id(line, type)
      case(type)
      when "ClientUserinfoChanged"
        new_line = line.split("ClientUserinfoChanged: ").last

        return remove_line_trash(new_line)
      when "Kill: 1022"
        new_line = line.split("Kill: 1022 ").last

        return remove_line_trash(new_line)
      when "Kill"
        new_line = line.split("Kill: ").last

        return new_line.split(" ").first
      when "Killed"
        new_line = line.split("Kill: ").last

        return new_line.split(" ")[1]
      when "ClientDisconnect"
        return line.split("ClientDisconnect: ").last.chomp
      else
        return ""
      end
    end

    def remove_line_trash(line)
      return line.slice(0..line.index(" ")-1)
    end
end
