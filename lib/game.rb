#!/usr/bin/env ruby

class Game
  attr_accessor :total_kills, :players, :name

  def initialize(name)
    @name = name
    @total_kills = 0
    @players = []
  end

  def find_player(line, type)
    return self.players.select{|p| p.id == get_id(line, type)}.first
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
