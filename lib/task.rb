#!/usr/bin/env ruby
require 'pry'
require 'json'
require 'awesome_print'
require './lib/game.rb'
require './lib/player.rb'
require './lib/parser.rb'

class Task
  include Parser

  def initialize
    @games = []
  end

  def resume_game
    info = []
    parse_log

    @games.each do |game|
      info << {
        "#{game.name}:" => {
          "total_kills": game.total_kills.to_i,
          "players": game.players.map(&:name).sort,
          "kills": game.players.map{|p| {p.name => p.kills}}.sort_by{|p|  p.first[0]}
        }
      }
    end

    info
  end
end
