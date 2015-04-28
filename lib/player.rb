#!/usr/bin/env ruby

class Player
  attr_accessor :id, :name, :kills

  def initialize(id)
    @id = id
    @kills = 0
  end
end
