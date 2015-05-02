#!/usr/bin/env ruby
require './lib/task'

task = Task.new

def show_options
  ap "Selecione uma das opções abaixo!"
  ap "1) Resumo dos jogos"
  ap "2) Resumo dos jogos com rank geral dos jogadores"
  ap "3) Resumo das mortes agrupadas"
  ap "4) Resumo das mortes traduzidas agrupadas"
  ap "5) Sair do teste"
end

ap "Olá, pronto para ver o resultado do log?"
show_options

option = STDIN.gets

while (option.chomp! != "5") do
  case(option.chomp())
    when "1"
      ap task.resume_game
    when "2"
      ap "Resumo:"
      ap task.resume_game
      ap "Rank:"
      ap task.rank_game
    when "3"
      ap task.means_deaths_game(false)
    when "4"
      ap task.means_deaths_game(true)
    else
      ap "Por favor,"
  end

  show_options
  option = STDIN.gets
end

ap "Espero que tenham gostado ;]"
ap "Abraços!"
