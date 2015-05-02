require 'spec_helper'
require './lib/parser'
require './lib/player'
require './lib/game'

RSpec.describe Parser do
  class AnonymousClass
    include Parser
  end

  let(:anonymous_class) {AnonymousClass.new}
  let(:meaning_kill_world) { "25:41 Kill: 1022 8 19: <world> killed Some Player by MOD_FALLING" }
  let(:meaning_kill_player) { "15:18 Kill: 5 5 7: Some Player killed Other Player by MOD_GRAPPLE" }

  describe "#create_player" do
    let(:new_connection) {"20:34 ClientConnect: 2"}
    let(:new_player) {" 20:34 ClientUserinfoChanged: 2 n\\Some Player\\t\\0\\model\\xian/default\\hmodel\\xian/default\\g_redteam\\\g_blueteam\\c1\\4\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0"}

    it "should create a new player" do
      expect(anonymous_class.instance_variable_get(:@player)).to be_nil

      anonymous_class.send(:create_player, new_connection)

      expect(anonymous_class.instance_variable_get(:@player).id).to eq("2")
    end

    it "should include the new player in game players's array" do
      anonymous_class.instance_variable_set(:@game, Game.new("game_1"))
      expect(anonymous_class.instance_variable_get(:@game).players).to eq([])

      player = Player.new("2")
      anonymous_class.instance_variable_set(:@player, player)

      anonymous_class.send(:create_player, new_player)

      expect(anonymous_class.instance_variable_get(:@game).players).to eq([player])
    end

    it "should set the player's name" do
      anonymous_class.instance_variable_set(:@game, Game.new("game_1"))

      player = Player.new("2")
      anonymous_class.instance_variable_set(:@player, player)

      anonymous_class.send(:create_player, new_player)

      expect(anonymous_class.instance_variable_get(:@player).name).to eq("Some Player")
    end
  end

  describe "#count_kills_by_world" do
    let(:world_kill) {"21:42 Kill: 1022 7 22: <world> killed Some Player by MOD_TRIGGER_HURT"}

    it "should decrement player kills" do
      anonymous_class.instance_variable_set(:@game, Game.new("game_1"))
      player = Player.new("7")
      player.kills = 10
      anonymous_class.instance_variable_get(:@game).players << player

      anonymous_class.send(:count_kills_by_world, world_kill)

      expect(anonymous_class.instance_variable_get(:@game).players.first.kills).to eq(9)
    end

    it "should increment player total_deaths" do
      anonymous_class.instance_variable_set(:@game, Game.new("game_1"))
      player = Player.new("7")
      player.total_deaths = 2
      anonymous_class.instance_variable_get(:@game).players << player

      anonymous_class.send(:count_kills_by_world, world_kill)

      expect(anonymous_class.instance_variable_get(:@game).players.first.total_deaths).to eq(3)
    end

    it "should add meaning of death to array" do
      anonymous_class.instance_variable_set(:@game, Game.new("game_1"))
      expect(anonymous_class.instance_variable_get(:@game).kills_by_means.size).to eq(0)

      player = Player.new("8")
      anonymous_class.instance_variable_get(:@game).players << player

      anonymous_class.send(:count_kills_by_world, meaning_kill_world)

      expect(anonymous_class.instance_variable_get(:@game).kills_by_means.size).to eq(1)
      expect(anonymous_class.instance_variable_get(:@game).kills_by_means.first).to eq("MOD_FALLING")
    end
  end

  describe "#count_kills_by_player" do
    let(:player_kill) {"22:06 Kill: 5 3 7: Some Player killed Another Player by MOD_ROCKET_SPLASH"}

    it "should increment player kills" do
      anonymous_class.instance_variable_set(:@game, Game.new("game_1"))
      player = Player.new("5")
      player2 = Player.new("3")
      player.kills = 4
      anonymous_class.instance_variable_get(:@game).players = [player, player2]

      anonymous_class.send(:count_kills_by_player, player_kill)

      expect(anonymous_class.instance_variable_get(:@game).players.first.kills).to eq(5)
    end

    it "should increment player total_kills" do
      anonymous_class.instance_variable_set(:@game, Game.new("game_1"))
      player = Player.new("5")
      player2 = Player.new("3")
      player.total_kills = 9
      anonymous_class.instance_variable_get(:@game).players = [player, player2]

      anonymous_class.send(:count_kills_by_player, player_kill)

      expect(anonymous_class.instance_variable_get(:@game).players.first.total_kills).to eq(10)
    end

    it "should increment player killed total_deaths" do
      anonymous_class.instance_variable_set(:@game, Game.new("game_1"))
      player = Player.new("5")
      player2 = Player.new("3")
      anonymous_class.instance_variable_get(:@game).players = [player, player2]

      anonymous_class.send(:count_kills_by_player, player_kill)

      expect(anonymous_class.instance_variable_get(:@game).players.last.total_deaths).to eq(1)
    end

    it "should add meaning of death to array" do
      anonymous_class.instance_variable_set(:@game, Game.new("game_1"))
      expect(anonymous_class.instance_variable_get(:@game).kills_by_means.size).to eq(0)

      player = Player.new("5")
      anonymous_class.instance_variable_get(:@game).players << player

      anonymous_class.send(:count_kills_by_player, meaning_kill_player)

      expect(anonymous_class.instance_variable_get(:@game).kills_by_means.size).to eq(1)
      expect(anonymous_class.instance_variable_get(:@game).kills_by_means.first).to eq("MOD_GRAPPLE")
    end
  end

  describe "#get_player_name" do
    let(:player) {"12:14 ClientUserinfoChanged: 5 n\\Player Name Here\\t\\0\\model\\sarge\\hmodel\\sarge\\g_redteam\\g_blueteam\\c1\\4\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0"}

    it "should get player name" do
      expect(anonymous_class.send(:get_player_name, player)).to eq("Player Name Here")
    end
  end

  describe "#get_meaning_death" do
    it "should get meaning death description" do
      expect(anonymous_class.send(:get_meaning_death, meaning_kill_player)).to eq("MOD_GRAPPLE")
    end
  end

  describe "#parser_log" do
    it "should count games" do
      anonymous_class.instance_variable_set(:@games, [])

      anonymous_class.parse_log

      expect(anonymous_class.instance_variable_get(:@games).size).to eq (21)
    end
  end
end
