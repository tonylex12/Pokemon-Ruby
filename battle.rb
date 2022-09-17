require_relative "./pokedex/moves"

class Battle
  include Pokedex
  # (complete parameters)
  attr_reader :player, :random_player

  def initialize(player, random_player)
    @player = player
    @random_player = random_player
    # Complete this
  end

  def start
    # Prepare the Battle (print messages and prepare pokemons)

    puts ""
    puts "#{@random_player.name} sent out #{random_player.pokemon.name}!"
    puts "#{player.name.capitalize} sent out #{player.pokemon.name}!"
    print "#{'-' * 19}Battle Start!#{'-' * 19}\n\n"

    hp_stats_show

    battle_loop
  end

  def select_first(player, random_player)
    player_move = player.pokemon.current_move
    random_player_move = random_player.pokemon.current_move

    if player_move[:priority] > random_player_move[:priority]
      player
    elsif player_move[:priority] < random_player_move[:priority]
      random_player
    elsif player.pokemon.stats[:speed] > random_player.pokemon.stats[:speed]
      player
    elsif player.pokemon.stats[:speed] < random_player.pokemon.stats[:speed]
      random_player
    else
      rand(2).zero? ? player : random_player
    end
  end

  def battle_loop
    until player.pokemon.fainted? || random_player.pokemon.fainted?
      prepare_players(player, random_player)
      players = attack_order(player, random_player)
      first = players[0]
      second = players[1]
      hp_stats_show
    end
    if first.pokemon.fainted?
      winner = second
      loser = first
    else
      winner = first
      loser = second
    end
    end_battle(player, winner, loser)
    player.pokemon.reset_hp
    winner
  end

  def hp_stats_show
    if !player.pokemon.fainted? && !random_player.pokemon.fainted?
      puts ""
      puts "#{player.name.capitalize}'s #{player.pokemon.name} - Level #{player.pokemon.level}!"
      puts "HP: #{player.pokemon.stats[:hp]}"
      puts "#{random_player.name.capitalize}'s #{random_player.pokemon.name} - Level #{random_player.pokemon.level}!"
      print "HP: #{random_player.pokemon.stats[:hp]}\n\n"
    end
  end

  def prepare_players(player, bot)
    player.pokemon.prepare_for_battle
    bot.pokemon.prepare_for_battle
    player.select_move
    bot.select_move
  end

  def end_battle(player, winner, loser)
    puts "#{loser.pokemon.name} FAINTED!"
    print "#{'-' * 50}\n"
    puts "#{winner.pokemon.name.capitalize} WINS!"
    player.pokemon.increase_stats(loser) if winner == player
    puts "#{'-' * 19}Battle Ended!#{'-' * 19}\n\n"
  end

  def attack_order(player, bot)
    first = select_first(player, bot)
    second = first == player ? bot : player
    print "#{'-' * 50}\n"
    first.pokemon.attack(second.pokemon) unless first.pokemon.fainted?
    second.pokemon.attack(first.pokemon) unless second.pokemon.fainted?
    [first, second]
  end
end
