#!/usr/bin/env ruby
require './lib/task'

task = Task.new

ap "Olá, pronto para ver o resultado do log?"

ap "Selecione uma das opções abaixo!"
ap "Resumo dos jogos: 1"
ap "Resumo dos jogos com rank dos jogadores: 2"
ap "Resumo das mortes agrupadas: 3"

option = STDIN.gets

case(option.chomp())
  when "1"
    ap task.resume_game
  when "2"
    ap "Resumo:"
    ap task.resume_game
    ap "Rank:"
    ap task.rank_game
  when "3"
end

ap "Espero que tenham gostado ;]"
ap "Abraços!"
