require_relative "./pokedex/moves"
require_relative "welcome_methods"
class Player
  include WelcomeMethods
  include Pokedex
  attr_reader :pokemon, :name, :level

  def initialize(name, chosen, pokemon_name, level = 1)
    @name = name
    @pokemon = Pokemon.new(chosen, pokemon_name, level)
  end

  def select_move
    # Complete this
    move = ""
    until @pokemon.moves.include?(move.downcase)
      puts "#{@pokemon.name.capitalize}, select your move:"
      print_options(@pokemon.moves)
      print "> "
      move = gets.chomp.downcase
    end
    @pokemon.current_move = MOVES[move]
    move
  end
end

# Create a class Bot that inherits from Player and override the select_move method
class Bot < Player
  def initialize(name, chosen, pokemon_name, level = 1)
    super
  end

  def select_move
    # Complete this
    move = @pokemon.moves.sample
    @pokemon.current_move = MOVES[move]
  end
end
