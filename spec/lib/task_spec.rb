require 'spec_helper'
require './lib/task'

RSpec.describe Task do
  let(:task) {Task.new}

  describe "#initialize" do
    it "should initialize games with empty array" do
      allow_any_instance_of(Parser).to receive(:parse_log).and_return(true)

      expect(task.instance_variable_get(:@games)).to eq([])
    end

    it "should call the parser" do
      expect(task.instance_variable_get(:@games).size).to eq(21)
    end
  end

  describe "#resume" do
    it "should return a hash with game name, total kills, players and players's kills" do
      expected = {"game_1:" => {
          "total_kills": 4,
          "players": ["Dono da Bola", "Isgalamido", "Zeh"],
          "kills": [
            {"Dono da Bola" => -1},
            {"Isgalamido" => 1},
            {"Zeh" => -2}
          ]
        }
      }

      game = Game.new("game_1")
      game.total_kills = 4
      player1 = Player.new(1)
      player2 = Player.new(3)
      player3 = Player.new(5)
      player1.name = "Zeh"
      player1.kills = -2
      player2.name = "Dono da Bola"
      player2.kills = -1
      player3.name = "Isgalamido"
      player3.kills = 1
      game.players = [player1, player2, player3]

      allow(File).to receive(:open) {StringIO.new("")}

      task = Task.new
      task.instance_variable_set(:@games, [game])

      expect(task.resume_game).to eq([expected])
    end
  end
end
