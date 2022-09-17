# require neccesary files
require_relative "./pokedex/pokemons"
require_relative "player"
require_relative "pokemon"
require_relative "welcome_methods"
require_relative "battle"

class Game
  include Pokedex
  include WelcomeMethods
  def start
    init_data = start_conditions
    name = init_data[:name]
    chosen = init_data[:chosen]
    pokemon_name = init_data[:pokemon_name]
    action = nil
    player = Player.new(name, chosen, pokemon_name)
    until action == "Exit"
      action = menu
      case action
      when "Stats"
        show_stats(player)
      when "Train"
        train(player)
      when "Leader"
        challenge_leader(player)
      when "Exit"
        goodbye
      end
    end
  end

  def train(player)
    random_chosen = POKEMONS.keys.sample
    random_level = rand(1..5)
    random_player = Bot.new("Random Person", random_chosen, random_chosen, random_level)
    puts "#{player.name.upcase} challenge #{random_player.name} for training"
    start_fight(player, random_player)
  end

  def challenge_leader(player)
    leader_player = Bot.new("Brock", "Onix", "Onix", 1)
    puts "#{player.name} challenge the Gym Leader #{leader_player.name} for a fight!"
    winner = start_fight(player, leader_player)
    if winner == player
      puts "Congratulation! You have won the game!"
      puts "You can continue training your Pokemon if you want"
    end
  end

  def show_stats(player)
    puts "#{player.pokemon.name}: "
    puts "Kind: #{player.pokemon.specie}"
    puts "Level: #{player.pokemon.level}"
    puts "Stats:"
    puts "HP: #{player.pokemon.stats[:hp]}"
    puts "Attack: #{player.pokemon.stats[:attack]}"
    puts "Defense: #{player.pokemon.stats[:defense]}"
    puts "Special Attack: #{player.pokemon.stats[:special_attack]}"
    puts "Special Defense: #{player.pokemon.stats[:special_defense]}"
    puts "Speed: #{player.pokemon.stats[:speed]}"
    puts "Experience points: #{player.pokemon.experience}\n\n"
  end

  def goodbye
    puts "Thanks for playing Pokemon Ruby"
    puts "This game was created with love by: Diego, Jesús y Antony."
  end

  def menu
    puts "#{'-' * 23}Menu#{'-' * 23}\n\n"
    puts "1. Stats        2. Train        3. Leader       4. Exit         \n\n"
    print "> "
    gets.chomp.strip.capitalize
  end

  def start_fight(player, bot)
    action = nil
    battle = Battle.new(player, bot)
    until ["Leave", "Fight"].include?(action)
      puts "#{bot.name} has a #{bot.pokemon.name} level #{bot.pokemon.level}"
      puts "What do you want to do now?"
      puts "1. Fight          2. Leave"
      print "> "
      action = gets.chomp.strip.capitalize
      case action
      when "Leave"
        break
      when "Fight"
        winner = battle.start
      end
    end
    winner
  end
end

game = Game.new
game.start
