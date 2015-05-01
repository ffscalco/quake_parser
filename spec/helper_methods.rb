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

  game
end
