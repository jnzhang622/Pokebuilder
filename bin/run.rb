require_relative '../config/environment'

prompt = TTY::Prompt.new


puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
puts '                                   (%#((((((#%%/                               '
puts '                           %**/////((((((((((((((((((((%                       '
puts '                      &******//////(((((((((((((((((((((((((/                  '
puts '                   *********/////((((((((((((((((((((((((((((((#               '
puts '                /***********////((((((((((((((((((((((((((((((((((%            '
puts '              *****,,,,,,,**///((((((((((((((((((((((((((((((((((((((          '
puts '            ******,,,,,,,***//(((((((((((((((((((((((((((((((((((((((((        '
puts '          %*****,,,,,,,,**///(((((((((((((((((((((((((((((((((((###(((((#      '
puts '         *******,,,,,,,**///((((((((%%%%%%%%%%%%%%&(((((((((((((####(((((#     '
puts '        ********,,,,***///(((((((%%%%%%%%%%%%%%%%%%%%%(((((((#(#%&@%%%%%%%%    '
puts '       **************///(((((((%%%%%%%.          *%#%%%%%%%%%%%%%%%%%%%%%%%%   '
puts '      %**********/////((((((((%%%%%%    ,      .    %%%%%%%%%%%%%%%%%%%%%%%%,  '
puts '      *****////////(((((((((#&%%%%#   /              %%%%%%%%%#,..,,,,,,,****  '
puts '     ,/////////((((((((&%%%%%%%%%%%   *              %%%%%,...........,,,****  '
puts '     (//////((((((@%%%%%%%%%%%%%%%%   (          #   %%%%%...       ...,,,***  '
puts '     *///(((((%%%%%%%%%%%%%%%%%%%%%%     *     ,    %%%%#...         ..,,,***  '
puts '      ((((%%%%%%%%%%%%%%%%%%(..&#%%%%%&          %%%%%%#..           ..,,,***  '
puts '      &%%%%%%%%%%%%%%%%/.,.......&%%%%%%%%%%%%%%%%%%%%...           ..,,,***&  '
puts '       %#%%%%%%%%%&,,.....        ..###%%%%%%%%%#%&...             ...,,,***   '
puts '       *%%%%%%%,,,,....               .  .........               ...,,,****    '
puts '        ,%%***,,,,....                                         ....,,,****     '
puts '          *****,,,,....                                       ...,,,,****      '
puts '           &*****,,,,....                                  ....,,,,****/       '
puts '             *******,,,,.....                           .....,,,,****&         '
puts '               %******,,,,,,........             ........,,,,,,****#           '
puts '                  ********,,,,,,,,,...............,,,,,,,,******/              '
puts '                     #**********,,,,,,,,,,,,,,,,,,,,,,*******&                 '
puts '                         %,******************************/                     '
puts '                               ,#****************/%.                           '
print TTY::Box.frame "                      Welcome to the Pokemon Team Builder App                    "

selection = ["Search by Input","Search by Generation","Search by Type","Browse Items","View/Edit Teams","Exit"]
input = nil
choice = nil
while choice != "Exit"
  choice = prompt.select("\nHow would you like to get started?", selection, cycle: true)
  
  if choice == "Search by Input" #Searches Pokemon by typing prompt through a list.
    print TTY::Box.frame "What Pokemon would you like to look at?\n"
    pokelist = PokeApi.get(pokemon: {offset: 0, limit: 1000}).results.map {|p| p.name}
    input = prompt.select("", pokelist, cycle: true,per_page: 20, filter: true)

    # begin
    #   input = gets.chomp.downcase
      pokequery = PokeApi.get(pokemon: input)
      puts "\nID: " + "#{pokequery.id}" + " - " + pokequery.name.capitalize
      puts "Type: " + pokequery.types.map {|t| t.type.name.capitalize}.join(" & ")
      puts "\n"
      adddontadd = prompt.select("\nWould you like to add this pokemon to a party?", ["Yes", "No"], cycle: true)
      if adddontadd == "Yes"
        puts "\nWhich team would you like to add this pokemon to?"
        teamsave = Team.find_or_create_by(name: gets.chomp)
        if teamsave.pokemons.count < 6
          nickname = prompt.select("\nWould you like to give it a nickname?", ["Yes", "No"], cycle: true)
          if nickname == "Yes"
            nickname = gets.chomp
          else
            nickname = pokequery.name
          end
          newpokemon = Pokemon.create!(team: teamsave, species: pokequery.name, name: nickname)
          abilitychoice = prompt.select("\nWhich ability would you like to add to #{pokequery.name}", [pokequery.abilities.map {|t| t.ability.name}])
          Ability.create(pokemon:newpokemon, name:abilitychoice, description:PokeApi.get(ability: abilitychoice).effect_entries[0].short_effect)
        else
          print TTY::Box.frame "There are six Pokemon in this team already. You cannot have anymore Pokemon on this team.\nReturning to main menu."
        end
      end
    # rescue
    #   print TTY::Box.frame "Unexpected Error Occured.\n#{input} might not be a valid Pokemon or there\nmight be a connection problem to the API"
    # end
  
  elsif choice == "Search by Generation" #Searches Pokemon with menu by Generation
    generation = ["Generation I", "Generation II", "Generation III", "Generation IV", "Generation V", "Generation VI", "Generation VII", "Exit"]
    gen = nil
    while gen != "Exit"
      gen = prompt.select("\nWhich generation would you like to look at?", generation, per_page: 8, cycle: true)
      if gen != "Exit"
        limit_var = nil
        offset_var = nil
        if gen == "Generation I" 
          limit_var = 151
          offset_var = 0
        elsif gen == "Generation II"
          limit_var = 100
          offset_var = 151
        elsif gen == "Generation III"
          limit_var = 135
          offset_var = 251
        elsif gen == "Generation IV"
          limit_var = 107
          offset_var = 386
        elsif gen == "Generation V"
          limit_var = 156
          offset_var = 493
        elsif gen == "Generation VI"
          limit_var = 72
          offset_var = 649
        elsif gen == "Generation VII"
          limit_var = 86
          offset_var = 721
        end
        genquery = PokeApi.get(pokemon: {limit: limit_var, offset: offset_var}).results.map {|p| p.name}
        genchoice = prompt.select("Please select your Pokemon", genquery , per_page: 20, cycle: true, filter: true)
        pokequery = PokeApi.get(pokemon: genchoice)
        puts "\nID: " + "#{pokequery.id}" + " - " + pokequery.name.capitalize
        puts "Type: " + pokequery.types.map {|t| t.type.name.capitalize}.join(" & ")
        puts "\n"
        
        adddontadd = prompt.select("\nWould you like to add this pokemon to a party?", ["Yes", "No"], cycle: true)
        if adddontadd == "Yes"
          puts "Which team would you like to add this pokemon to?"
          teamsave = Team.find_or_create_by(name: gets.chomp)
          if teamsave.pokemons.count < 6
            nickname = prompt.select("\nWould you like to give it a nickname?", ["Yes", "No"], cycle: true)
            if nickname == "Yes"
              nickname = gets.chomp
            else
              nickname = pokequery.name
            end
            newpokemon = Pokemon.create!(team: teamsave, species: pokequery.name, name: nickname)
            abilitychoice = prompt.select("\nWhich ability would you like to add to #{pokequery.name}", [pokequery.abilities.map {|t| t.ability.name}], cycle: true)
            Ability.create(pokemon:newpokemon, name:abilitychoice, description:PokeApi.get(ability: abilitychoice).effect_entries[0].short_effect)
          else
            print TTY::Box.frame "There are six Pokemon in this team already. You can not have anymore Pokemon on this team.\nReturning to previous menu."
          end
        end
      end
    end
  elsif choice == "Search by Type"
    poketypes = ["Normal","Fire","Fighting","Water","Flying","Grass","Poison","Electric","Ground","Psychic","Rock","Ice","Bug","Dragon","Ghost","Dark","Steel","Fairy"]
    typesearch = prompt.select("\nWhich type would you like to look at?", poketypes, per_page: 18, cycle: true, filter: true)
    typequery = PokeApi.get(type: typesearch.downcase)
    input = prompt.select("\nWhich #{typesearch} type Pokemon would you like to look at?", typequery.pokemon.map {|p| p.pokemon.name}, per_page: 20, cycle: true, filter: true)
    pokequery = PokeApi.get(pokemon: input)
    puts "\nID: " + "#{pokequery.id}" + " - " + pokequery.name.capitalize
    puts "Type: " + pokequery.types.map {|t| t.type.name.capitalize}.join(" & ")
    puts "\n"
    adddontadd = prompt.select("\nWould you like to add this pokemon to a party?", ["Yes", "No"], cycle: true)
    if adddontadd == "Yes"
      puts "\nWhich team would you like to add this pokemon to?"
      teamsave = Team.find_or_create_by(name: gets.chomp)
      if teamsave.pokemons.count < 6
        nickname = prompt.select("\nWould you like to give it a nickname?", ["Yes", "No"], cycle: true)
        if nickname == "Yes"
          nickname = gets.chomp
        else
          nickname = pokequery.name
        end
        newpokemon = Pokemon.create!(team: teamsave, species: pokequery.name, name: nickname)
        abilitychoice = prompt.select("\nWhich ability would you like to add to #{pokequery.name}", [pokequery.abilities.map {|t| t.ability.name}])
        Ability.create(pokemon:newpokemon, name:abilitychoice, description:PokeApi.get(ability: abilitychoice).effect_entries[0].short_effect)
      else
        print TTY::Box.frame "There are six Pokemon in this team already. You cannot have anymore Pokemon on this team.\nReturning to main menu."
      end
    end
    
  elsif choice == "Browse Items"
    itemlist = PokeApi.get(item_attribute: "holdable-active").items
    itemlistnames = [itemlist.map {|i| i.name}]
    itemselect = prompt.select("\nHere is a list of #{itemlist.count} items, which would you like to look at?", itemlistnames, per_page: 20, cycle: true, filter: true)
    itemquery = PokeApi.get(item: itemselect)
    puts "\n"
    puts itemquery.name.capitalize
    puts itemquery.effect_entries[0].short_effect
    yesno = prompt.select("\nWould you like to add #{itemquery.name.capitalize} to a Pokemon on your teams?", ["Yes", "No"], cycle: true)
    if yesno == "Yes"
      viewteam = prompt.select("\nWhat team is the Pokemon on?\n", Team.all.map {|v| v.name}, cycle: true)
      teamselect = Team.all.find_by(name: viewteam)
      viewstats = teamselect.pokemons.map do |p| 
        puts " "
        puts "Team: " + "#{p.team.name}" + ", Species: " + "#{p.species}" + ", Name: " + "#{p.name}"
        puts "Ability: " + "#{p.abilities[0].name}" + " - #{p.abilities[0].description}"
        if p.helditems != []
          puts "Held Item: " + "#{p.helditems[0].name}"
        end
        if p.attacks != []
          puts "Attacks: " + "#{p.attacks[0].name}" + ", " + "#{p.attacks[1].name}" + ", " + "#{p.attacks[2].name}" + ", " + "#{p.attacks[3].name}" end
        end
        puts " "
        pokemonselect = prompt.select("\nWhat Pokemon do want to hold the #{itemquery.name.capitalize}?\n", teamselect.pokemons.map {|p| p.name}, cycle: true)
          input = teamselect.pokemons.find_by(name: pokemonselect)
          if input.helditems.count == 0
            Helditem.create(pokemon: input, name: itemquery.name.capitalize, description: itemquery.effect_entries[0].short_effect)
          else
            input.helditems[0].update(:name => itemquery.name, :description => itemquery.effect_entries[0].short_effect)
          end
        end

  elsif choice == "View/Edit Teams" #Edits any existing teams
    viewteam = prompt.select("\nWhich Team would you like to look at?", Team.all.map {|v| v.name}, cycle: true)
    teamselect = Team.all.find_by(name: viewteam)
    puts "\n\n Team: " + "#{teamselect.name}"
    viewstats = teamselect.pokemons.map do |p| 
      puts " "
      puts "   Name: " + "#{p.name}"
      puts "   Species: " + "#{p.species.capitalize}"
      puts "     Ability: " + "#{p.abilities[0].name.capitalize}" + " - #{p.abilities[0].description}"
      if p.helditems != []
        puts "     Held Item: " + "#{p.helditems[0].name.capitalize}" + " - #{p.helditems[0].description}"
      end
      if p.attacks != []
        puts "     Attacks: " + "#{p.attacks[0].name.capitalize}" + ", " + "#{p.attacks[1].name}" + ", " + "#{p.attacks[2].name}" + ", " + "#{p.attacks[3].name}" end
      end
      puts " "
    teammenu = ["Edit Pokemon Entries", "View Team", "Change Team Name", "Delete Team", "Exit"]
    teamoptions = nil
    while teamoptions != "Exit"
      teamoptions = prompt.select("\nWhat would you like to do?", teammenu, cycle: true)
        if teamoptions == "Edit Pokemon Entries"
          pokemonmapmenu = [teamselect.pokemons.map {|p| p.name}, "Exit"]
          pokemonselect = nil
          while pokemonselect != "Exit"
            pokemonselect = prompt.select("\nWho would you like to look at?", pokemonmapmenu, cycle: true)
            if pokemonselect != "Exit"
              input = teamselect.pokemons.find_by(name: pokemonselect)
              pokequery = PokeApi.get(pokemon: input.species)
              puts "\n\n"
              puts "   Name: " + "#{input.name}"
              puts "   Species: " + "#{input.species.capitalize}" 
              puts "     Ability: " + "#{input.abilities[0].name.capitalize}" + " - #{input.abilities[0].description}"
              if input.helditems != []
                puts "     Held Item: " + "#{input.helditems[0].name.capitalize}" + " - #{input.helditems[0].description}"
              end
              if input.attacks != []
                puts "     Attacks: " + "#{input.attacks[0].name.capitalize}" + ", " + "#{input.attacks[1].name.capitalize}" + ", " + "#{input.attacks[2].name.capitalize}" + ", " + "#{input.attacks[3].name.capitalize}" 
              end
              puts "\n"
              anothermenu = ["Change Nickname", "Edit Ability", "Add/Edit Held Item", "Add/Edit Attacks", "Remove Pokemon", "Exit"]
              pokemonselectaction = nil
              while pokemonselectaction != "Exit"
                pokemonselectaction = prompt.select("\nWhat would you like to do with #{pokemonselect.chomp}?", anothermenu, cycle: true)
                  if pokemonselectaction == "Change Nickname"
                    puts "What would you like to change #{pokemonselect}'s name to?"
                    input.update(:name => gets.chomp)
                  elsif pokemonselectaction == "Edit Ability"
                    newability = prompt.select("\nWhich ability would you like #{pokemonselect.chomp}'s to change to?", [pokequery.abilities.map {|t| t.ability.name}], cycle: true)
                    abilityquery = PokeApi.get(ability: newability)
                    input.abilities[0].update(:name => abilityquery.name, :description => abilityquery.effect_entries[0].short_effect)
                  elsif pokemonselectaction == "Add/Edit Held Item"
                    itemlist = PokeApi.get(item_attribute: "holdable-active").items
                    itemlistnames = [itemlist.map {|i| i.name}]
                    itemselect = prompt.select("\nWhat item would you like #{input.name} to hold?", itemlistnames, per_page: 20, cycle: true, filter: true)
                    itemquery = PokeApi.get(item: itemselect)
                    puts "\n"
                    puts itemquery.name.capitalize
                    puts itemquery.effect_entries[0].short_effect
                    puts "\n"
                    if input.helditems.count < 1
                      Helditem.create(pokemon: input, name: itemquery.name.capitalize, description: itemquery.effect_entries[0].short_effect)
                    elsif input.helditems.count > 0
                      input.helditems[0].update(:name => itemquery.name, :description => itemquery.effect_entries[0].short_effect)
                    end

                  elsif pokemonselectaction == "Add/Edit Attacks"
                    if input.attacks == []
                      while input.attacks.count < 4
                        attackselect = prompt.select("\nPlease select #{pokemonselect.chomp}'s attacks?", pokequery.moves.map {|m| m.move.name}, per_page: 20, cycle: true, filter: true)
                        attackquery = PokeApi.get(move: attackselect)
                        Attack.create(pokemon:input, name:attackquery.name, atk_type:attackquery.type.name, power:attackquery.power, description:attackquery.effect_entries[0].short_effect)
                      end
                    else
                      puts " "
                      puts "   " + input.attacks[0].name.capitalize + " - " + input.attacks[0].description
                      puts "   " + input.attacks[1].name.capitalize + " - " + input.attacks[1].description
                      puts "   " + input.attacks[2].name.capitalize + " - " + input.attacks[2].description
                      puts "   " + input.attacks[3].name.capitalize + " - " + input.attacks[3].description
                      attackselect = prompt.select("\nWhich of #{input.name.chomp}'s attacks would you like to change?", input.attacks.map {|m| m.name}, cycle: true)
                      attackedit = input.attacks.find_by(name: attackselect)
                      newattack = prompt.select("\nPlease select #{pokemonselect.chomp}'s new attack?", pokequery.moves.map {|m| m.move.name}, per_page: 20, cycle: true, filter: true)
                      attackquery = PokeApi.get(move: newattack)
                      attackedit.update(:name => attackquery.name, :atk_type => attackquery.type.name, :power => attackquery.power, :description => attackquery.effect_entries[0].short_effect)
                    end
                  elsif pokemonselectaction == "Remove Pokemon"
                    input.attacks.map {|p| p.destroy}
                    input.helditems.map {|p| p.destroy}
                    input.abilities.map {|p| p.destroy}
                    input.destroy
                  end
              end
            end
          end
        elsif teamoptions == "View Team"
          viewstats = teamselect.pokemons.map do |p| 
            puts " "
            puts "   Name: " + "#{p.name}"
            puts "   Species: " + "#{p.species.capitalize}"
            puts "     Ability: " + "#{p.abilities[0].name.capitalize}" + " - #{p.abilities[0].description}"
            if p.helditems != []
              puts "     Held Item: " + "#{p.helditems[0].name.capitalize}" + " - #{p.helditems[0].description}"
            end
            if p.attacks != []
              puts "     Attacks: " + "#{p.attacks[0].name.capitalize}" + ", " + "#{p.attacks[1].name.capitalize}" + ", " + "#{p.attacks[2].name.capitalize}" + ", " + "#{p.attacks[3].name.capitalize}" end
            end
            puts " "

        elsif teamoptions == "Change Team Name"
          puts "What would you like to change #{teamselect.name}'s name to?"
          teamselect.update(:name => gets.chomp)

        elsif teamoptions == "Delete Team" #Deletes team and all assiciated items, attacks and abilities.
          yesno = prompt.select("\nAre you sure you want to delete this team??", ["No", "Yes"], cycle: true)
          if yesno == "Yes"
            teamselect.pokemons.map {|p| p.attacks.destroy}
            teamselect.pokemons.map {|p| p.helditems.destroy}
            teamselect.pokemons.map {|p| p.abilities.destroy}
            teamselect.pokemons.map {|p| p.destroy}
            teamselect.destroy
          end
        end
      
    end
  end
end
