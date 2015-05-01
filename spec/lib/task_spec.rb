require 'spec_helper'
require './spec/helper_methods'
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

  describe "#resume_game" do
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

      allow_any_instance_of(Parser).to receive(:parse_log).and_return(true)

      task = Task.new
      task.instance_variable_set(:@games, [simple_game])

      expect(task.resume_game).to eq([expected])
    end
  end
end
