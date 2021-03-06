#!/usr/bin/env ruby
module Parser
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

  private
    def create_player(line)
      @player = Player.new(line.chomp('')[-1, 1]) if line.include? "ClientConnect:"

      if line.include? "ClientDisconnect:"
        @player = @game.find_player(line, "ClientDisconnect")

        @player.online = false
      end

      if line.include? "ClientUserinfoChanged:"
        player_name = get_player_name(line)
        exist_player = @game.find_player(line, "ClientUserinfoChanged", player_name)

        exist_player.nil? ? @game.players << @player : @player = exist_player

        @player.name = player_name
      end
    end

    def count_kills_by_world(line)
      player = @game.find_player(line, "Kill: 1022")
      player.kills -= 1
      player.total_deaths += 1

      @game.kills_by_means << get_meaning_death(line)
    end

    def count_kills_by_player(line)
      player = @game.find_player(line, "Kill")
      player.kills += 1
      player.total_kills += 1

      player = @game.find_player(line, "Killed")
      player.total_deaths += 1

      @game.kills_by_means << get_meaning_death(line)
    end

    def get_player_name(line)
      return line.slice(line.index("\\")..-1).split("\\t").first.delete("\\")
    end

    def get_meaning_death(line)
      str_to_cut = " by "

      return line.slice(line.index(str_to_cut)..-1).delete(str_to_cut).chomp()
    end
end
