require_relative "pokedex/pokemons"
module WelcomeMethods
  include Pokedex
  def welcome_message
    print "#{'#$' * 25}\n"
    puts "#{'#$' * 7} #{' ' * 20} #{'#$' * 7}"
    puts "#{'#$' * 5} #{'-' * 3} #{' ' * 3} Pokemon Ruby #{' ' * 3} #{'-' * 3} #{'#$' * 5}"
    puts "#{'#$' * 7} #{' ' * 20} #{'#$' * 7}"
    print "#{'#$' * 25}\n\n"
    puts "Hello there! Welcome to the world of POKEMON! My name is OAK!"
    print "People call me the POKEMON PROF!\n\n"
    puts "This world is inhabited by creatures called POKEMON! For some"
    puts "people, POKEMON are pets. Others use them for fights. Myself..."
    puts "I study POKEMON as a profession."
  end

  def prompt_name(prompt)
    input = ""
    while input.empty?
      puts prompt
      print "> "
      input = gets.chomp.strip
    end
    input
  end

  def message_name(name)
    puts "Right! So your name is #{name.upcase}!"
    puts "Your very own POKEMON legend is about to unfold! A world of"
    puts "dreams and adventures with POKEMON awaits! Let's go!"
    puts "Here, #{name.upcase}! There are 3 POKEMON here! Haha!"
    puts "When I was young, I was a serious POKEMON trainer."
    print "In my old age, I have only 3 left, but you can have one! Choose!\n\n"
  end

  def print_options(options)
    options.each_with_index do |option, i|
      print "#{i + 1}. #{option}#{' ' * 6}"
    end
    puts ""
  end

  def chose_pokemon(options)
    chosen = ""
    until options.include?(chosen)
      print "> "
      chosen = gets.chomp.strip.capitalize
    end
    puts ""
    puts "You selected #{chosen.upcase}. Great choice!"
    chosen
  end

  def give_name(chosen)
    print "Give your pokemon a name?\n"
    print "> "
    name = gets.chomp
    name = chosen if name.empty?
    name
  end

  def final_message(name, pokemon_name)
    puts "#{name.upcase}, raise your young #{pokemon_name.upcase} by making it fight!"
    puts "When you feel ready you can challenge BROCK, the PEWTER's GYM LEADER"
  end

  def start_conditions
    welcome_message
    name = prompt_name("First, what is your name?")
    message_name(name)
    options = POKEMONS.keys.slice(0, 3)
    print_options(options)
    chosen = chose_pokemon(options)
    pokemon_name = give_name(chosen)
    final_message(name, pokemon_name)
    { name: name, chosen: chosen, pokemon_name: pokemon_name }
  end
end
