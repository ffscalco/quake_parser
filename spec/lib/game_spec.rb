require 'spec_helper'
require './lib/game'
require './lib/player'

RSpec.describe Game do
  let(:game) {Game.new("game_1")}
  let(:line_client) { "20:34 ClientUserinfoChanged: 10 n\/Isgalamido\/t\/0\/model\/xian/default\/hmodel\/xian/" }
  let(:line_world) { "20:54 Kill: 1022 11 22: <world> killed Isgalamido by MOD_TRIGGER_HURT" }
  let(:line_kill) { "22:06 Kill: 15 28 7: Isgalamido killed Mocinha by MOD_ROCKET_SPLASH" }
  let(:line_disconnect) { "21:10 ClientDisconnect: 10" }

  describe "#initialize" do
    it "should initialize name with param value" do
      expect(game.instance_variable_get(:@name)).to eq("game_1")
    end

    it "should initialize total_kills with zero" do
      expect(game.instance_variable_get(:@total_kills)).to eq(0)
    end

    it "should initialize players with empty array" do
      expect(game.instance_variable_get(:@players)).to eq([])
    end

    it "should initialize kills_by_means with empty array" do
      expect(game.instance_variable_get(:@kills_by_means)).to eq([])
    end
  end

  describe "#get_id" do
    it "should return the id of the client userinfo" do
      expect(game.send(:get_id, line_client, "ClientUserinfoChanged")).to eq("10")
    end

    it "should return the id of the client who died by the world" do
      expect(game.send(:get_id, line_world, "Kill: 1022")).to eq("11")
    end

    it "should return the id of the client who killed someone" do
      expect(game.send(:get_id, line_kill, "Kill")).to eq("15")
    end

    it "should return the id of the client that died" do
      expect(game.send(:get_id, line_kill, "Killed")).to eq("28")
    end

    it "should return the id of the client disconnect" do
      expect(game.send(:get_id, line_disconnect, "ClientDisconnect")).to eq("10")
    end

    it "should return blank if type is not in some case alternative" do
      expect(game.send(:get_id, line_kill, "Kill_something")).to eq("")
    end
  end

  describe "#find_player" do
    let(:player1) { Player.new("10") }
    let(:player2) { Player.new("11") }
    let(:player3) { Player.new("15") }

    it "should return player with id 10" do
      game.players << player1
      expect(game.find_player(line_client, "ClientUserinfoChanged")).to eq(player1)
    end

    it "should return player with id 11" do
      game.players << player2
      expect(game.find_player(line_world, "Kill: 1022")).to eq(player2)
    end

    it "should return player with id 15" do
      game.players << player3
      expect(game.find_player(line_kill, "Kill")).to eq(player3)
    end

    it "should return nil if don't find the player" do
      expect(game.find_player(line_kill, "Kill_something")).to be_nil
    end
  end

  describe "#count_kills_by_means" do
    it "should return a translated hash grouped by mean" do
      game = Game.new("game_1")
      game.kills_by_means = ["MOD_SHOTGUN", "MOD_GAUNTLET", "MOD_SHOTGUN", "MOD_CRUSH","MOD_LAVA", "MOD_SHOTGUN", "MOD_CRUSH"]

      expected = {
        "Shotgun" => 3,
        "Was squished" => 2,
        "Gauntlet" => 1,
        "Soes a back flip into the lava" => 1
      }

      expect(game.send(:count_kills_by_means, true)).to eq(expected)
    end

    it "should return a hash grouped by mean" do
      game = Game.new("game_1")
      game.kills_by_means = ["MOD_SHOTGUN", "MOD_GAUNTLET", "MOD_SHOTGUN", "MOD_CRUSH","MOD_LAVA", "MOD_SHOTGUN", "MOD_CRUSH"]

      expected = {
        "MOD_SHOTGUN" => 3,
        "MOD_CRUSH" => 2,
        "MOD_GAUNTLET" => 1,
        "MOD_LAVA" => 1
      }

      expect(game.send(:count_kills_by_means, false)).to eq(expected)
    end
  end
end
