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

    parse_log
  end

  def resume_game
    info = []

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

  def rank_game
    rank = {}

    @games.each do |game|
      game.players.each do |player|
        mapped_player = rank.select{|p| p == player.name }.first

        if mapped_player.nil?
          rank[player.name] = mount_player_rank(player)
        else
          rank[player.name]["total_kills"] += player.total_kills
          rank[player.name]["total_deaths"] += player.total_deaths
        end
      end
    end

    rank.sort_by{|key, value| -value["total_kills"]}.to_h
  end

  private
    def mount_player_rank(player)
      return {
        "total_kills" => player.total_kills,
        "total_deaths" => player.total_deaths
      }
    end
end
