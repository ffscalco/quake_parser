#!/usr/bin/env ruby

class Player
  attr_accessor :id, :name, :kills, :total_kills, :total_deaths, :online

  def initialize(id)
    @id = id
    @kills = 0
    @total_kills = 0
    @total_deaths = 0
    @online = true
  end

  def to_s
    self.name
  end

  def online?
    self.online
  end
end
