require 'spec_helper'
require './lib/player'

RSpec.describe Player do
  let(:player) {Player.new(1)}

  describe "#initialize" do
    it "should initialize id with param value" do
      expect(player.instance_variable_get(:@id)).to eq(1)
    end

    it "should initialize kills with zero" do
      expect(player.instance_variable_get(:@kills)).to eq(0)
    end

    it "should initialize total_kills with zero" do
      expect(player.instance_variable_get(:@total_kills)).to eq(0)
    end

    it "should initialize total_deaths with zero" do
      expect(player.instance_variable_get(:@total_deaths)).to eq(0)
    end

    it "should initialize online with true" do
      expect(player.instance_variable_get(:@online)).to eq(true)
    end
  end

  describe "#to_s" do
    it "should return de player's name" do
      player.name = "Some Name"
      expect(player.to_s).to eq("Some Name")
    end
  end

  describe "#online?" do
    it "should return true if player is online" do
      expect(player.online?).to eq(true)
    end

    it "should return false if player is offline" do
      player.online = false
      expect(player.online?).to eq(false)
    end
  end
end
