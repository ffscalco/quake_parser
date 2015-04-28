require 'spec_helper'
require 'pry'
require './lib/game'
require './lib/player'

RSpec.describe Game do
  let(:game) {Game.new("game_1")}
  let(:line_client) { "20:34 ClientUserinfoChanged: 2 n\/Isgalamido\/t\/0\/model\/xian/default\/hmodel\/xian/" }
  let(:line_world) { "20:54 Kill: 1022 5 22: <world> killed Isgalamido by MOD_TRIGGER_HURT" }
  let(:line_kill) { "22:06 Kill: 8 3 7: Isgalamido killed Mocinha by MOD_ROCKET_SPLASH" }

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
  end

  describe "#get_id" do
    it "should return the id of the client userinfo" do
      expect(game.send(:get_id, line_client, "ClientUserinfoChanged")).to eq("2")
    end

    it "should return the id of the client who died by the world" do
      expect(game.send(:get_id, line_world, "Kill: 1022")).to eq("5")
    end

    it "should return the id of the client who killed someone" do
      expect(game.send(:get_id, line_kill, "Kill")).to eq("8")
    end

    it "should return blank if type is not in some case alternative" do
      expect(game.send(:get_id, line_kill, "Kill_something")).to eq("")
    end
  end

  describe "#find_player" do
    let(:player1) { Player.new("2") }
    let(:player2) { Player.new("5") }
    let(:player3) { Player.new("8") }

    it "should return player with id 2" do
      game.players << player1
      expect(game.find_player(line_client, "ClientUserinfoChanged")).to eq(player1)
    end

    it "should return player with id 5" do
      game.players << player2
      expect(game.find_player(line_world, "Kill: 1022")).to eq(player2)
    end

    it "should return player with id 8" do
      game.players << player3
      expect(game.find_player(line_kill, "Kill")).to eq(player3)
    end

    it "should return nil if don't find the player" do
      expect(game.find_player(line_kill, "Kill_something")).to be_nil
    end
  end
end
