# require neccesary files
require_relative "./pokedex/pokemons"
require_relative "./pokedex/moves"

class Pokemon
  # include neccesary modules
  include Pokedex
  # (complete parameters)
  attr_reader :specie, :name, :experience, :moves, :type, :stat_effort_value, :effort_points
  attr_accessor :current_move, :stats, :hp_max, :level

  def initialize(chosen, pokemon_name, level)
    @specie = chosen
    @name = pokemon_name
    @level = level
    @effort_points = POKEMONS[@specie][:effort_points]
    @moves = POKEMONS[@specie][:moves]
    @current_move = nil
    @experience = 0
    @hp_max = nil
    @type = POKEMONS[@specie][:type]
    @base_exp = POKEMONS[@specie][:base_exp]
    @base_stats = POKEMONS[@specie][:base_stats]
    @stats = { hp: 0, attack: 0, defense: 0, special_attack: 0, special_defense: 0, speed: 0 }
    @stat_effort_value = { hp: 0, attack: 0, defense: 0, special_attack: 0, special_defense: 0, speed: 0 }
    @ind_value = { hp: rand(0..31), attack: rand(0..31), defense: rand(0..31), special_attack: rand(0..31),
                   special_defense: rand(0..31), speed: rand(0..31) }
    @stats.each do |stat, _value|
      calc_stats = (2 * @base_stats[stat]) + @ind_value[stat] + (@stat_effort_value[stat] / 4).floor
      base_for_st =  calc_stats * @level / 100
      @stats[stat] = if stat == :hp
                       (base_for_st + @level + 10).floor
                     else
                       (base_for_st + 5).floor
                     end
      @hp_max = @stats[:hp]
    end
    # hp: 45, attack: 49, defense: 49, special_attack: 65, special_defense: 65, speed: 45
    # Retrieve pokemon info from Pokedex and set instance variables
    # Calculate Individual Values and store them in instance variable
    # Create instance variable with effort values. All set to 0
    # Store the level in instance variable
    # If level is 1, set experience points to 0 in instance variable.
    # If level is not 1, calculate the minimum experience point for that level and store it in instance variable.
    # Calculate pokemon stats and store them in instance variable
  end

  def prepare_for_battle
    # Complete this
    @hp_max = @stats[:hp]
    @current_move = nil
  end

  def receive_damage(damage)
    @stats[:hp] -= damage
  end

  def set_current_move
    # Complete this
    @current_move
  end

  def fainted?
    !@stats[:hp].positive?
    # Complete this
  end

  def attack(target)
    puts "#{@name} used #{@current_move[:name].upcase}!"
    if @current_move[:accuracy] > rand(1..100)
      critical_hit = _getcrit
      multiplier = _getmultiplier(target)

      if SPECIAL_MOVE_TYPE.include?(@current_move[:type])
        offensive_stat = @stats[:special_attack]
        target_defensive_stat = target.stats[:special_defense]
      else
        offensive_stat = @stats[:attack]
        target_defensive_stat = target.stats[:defense]
      end

      move_power = @current_move[:power]
      hit_ratio = critical_hit * multiplier
      damage_calc = offensive_stat * move_power / target_defensive_stat
      damage = ((((((2 * @level / 5.0) + 2).floor * damage_calc).floor / 50.0).floor + 2) * hit_ratio).floor

      puts "And it hit #{target.name} with #{damage} damage."

      target.receive_damage(damage)
    else
      puts "#{@name}'s attack missed"
    end
    print "#{'-' * 50}\n"
  end

  def increase_stats(target)
    # Increase stats base on the defeated pokemon and print message "#[pokemon name] gained [amount] experience points"
    amount_stats = target.pokemon.effort_points[:amount]
    type_stats = target.pokemon.effort_points[:type]
    @stat_effort_value[type_stats] += amount_stats
    gained_point = (@base_exp * target.pokemon.level / 7.0).floor
    @experience += gained_point
    exp = ((6 / 5 * (@level.next**3)) - (15 * (@level.next**2)) + (100 * @level.next) - 140).floor
    puts "#{@name} gained #{gained_point} experience points"
    if @experience >= exp
      @level += 1
      puts "#{@name} reached level #{@level}"
      @stats.each do |stat, _value|
        calc_stats = (2 * @base_stats[stat]) + @ind_value[stat] + (@stat_effort_value[stat] / 4).floor
        base_for_st =  calc_stats * @level / 100
        @stats[stat] = if stat == :hp
                         (base_for_st + @level + 10).floor
                       else
                         (base_for_st + 5).floor
                       end
        @hp_max = @stats[:hp]
      end
    end
    # If the new experience point are enough to level up, do it and print
    # message "#[pokemon name] reached level [level]!" # -- Re-calculate the stat
  end

  # private methods:
  # Create here auxiliary methods
  def reset_hp
    base_for_reset = (((2 * @base_stats[:hp]) + @ind_value[:hp] + (@stat_effort_value[:hp] / 4).floor) * @level / 100)
    @stats[:hp] = (base_for_reset + @level + 10).floor
  end

  def _getcrit
    critical_hit = 1
    if rand(1..16) == 1
      critical_hit = 1.5
      puts "It was a CRITICAL HIT!"
    end
    critical_hit
  end

  def _getmultiplier(target)
    p_type = @current_move[:type]
    r_type = target.type

    get_mul = TYPE_MULTIPLIER.find do |type|
      p_type == type[:user] && r_type.include?(type[:target])
    end
    multiplier = if get_mul.nil?
                   1
                 else
                   get_mul[:multiplier]
                 end

    case multiplier
    when 2
      puts "It's super effective!"
    when 0.5
      puts "It's not very effective..."
    end
    multiplier
  end
end
