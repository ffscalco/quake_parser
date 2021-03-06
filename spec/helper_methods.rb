def simple_game
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
  game.kills_by_means = ["MOD_SHOTGUN", "MOD_GAUNTLET", "MOD_SHOTGUN", "MOD_CRUSH","MOD_LAVA", "MOD_SHOTGUN", "MOD_CRUSH"]

  game
end

def medium_game
  games = []

  game = Game.new("game_1")
  game.total_kills = 5
  player1 = Player.new(1)
  player2 = Player.new(3)
  player3 = Player.new(5)
  player1.name = "Zeh"
  player1.kills = -2
  player1.total_deaths = 2
  player1.total_kills = 0
  player2.name = "Dono da Bola"
  player2.kills = -1
  player2.total_deaths = 1
  player2.total_kills = 1
  player3.name = "Isgalamido"
  player3.kills = 1
  player3.total_deaths = 0
  player3.total_kills = 1
  game.players = [player1, player2, player3]

  games << game

  game = Game.new("game_2")
  game.total_kills = 6
  player1 = Player.new(1)
  player2 = Player.new(3)
  player3 = Player.new(5)
  player1.name = "Mal"
  player1.kills = 3
  player1.total_deaths = 0
  player1.total_kills = 3
  player2.name = "Dono da Bola"
  player2.kills = 1
  player2.total_deaths = 1
  player2.total_kills = 0
  player3.name = "Zeh"
  player3.kills = 0
  player3.total_deaths = 1
  player3.total_kills = 1
  game.players = [player1, player2, player3]

  games << game

  games
end
