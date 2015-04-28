#!/usr/bin/env ruby
require 'pry'
require 'json'
require 'awesome_print'
require './lib/game.rb'
require './lib/player.rb'

class Task
  def initialize
    @games = []
  end

  private
    def parse_log
      File.open("games.log", "r") do |log|
        log.each_line do |line|

          if line.include? "InitGame:"
            @games << @game unless @game.nil?
            @game = Game.new("game_#{@games.size+1}")
          end

          @game.total_kills += 1 if line.include? "Kill:"

          create_player(line)

          count_kills_by_world(line) if line.include? "<world>"

          count_kills_by_player(line) if line.include? "Kill:" and !(line.include? "<world>")

          if line.include? "ShutdownGame:"
            @games << @game
            @game = nil
          end
        end
      end
    end

    def create_player(line)
      @player = Player.new(line.chomp('')[-1, 1]) if line.include? "ClientConnect:"

      if line.include? "ClientUserinfoChanged:"
        exist_player = @game.find_player(line, "ClientUserinfoChanged")

        exist_player.nil? ? @game.players << @player : @player = exist_player

        @player.name = line.slice(line.index("\\")..-1).split("\\t").first.delete("\\")
      end
    end

    def count_kills_by_world(line)
      player = @game.find_player(line, "Kill: 1022")
      player.kills -= 1
    end

    def count_kills_by_player(line)
      player = @game.find_player(line, "Kill")
      player.kills += 1
    end

end
