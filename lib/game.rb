#!/usr/bin/env ruby

class Game
  attr_accessor :total_kills, :players, :name

  def initialize(name)
    @name = name
    @total_kills = 0
    @players = []
  end
end
