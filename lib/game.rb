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

  def find_player(line, type)
    return self.players.select{|p| p.id == get_id(line, type)}.first
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
        return line.split("ClientUserinfoChanged: ").last[0]
      when "Kill: 1022"
        return line.split("Kill: 1022 ").last[0]
      when "Kill"
        return line.split("Kill: ").last[0]
      else
        return ""
      end
    end
end
