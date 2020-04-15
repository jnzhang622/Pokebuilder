generation = ["Generation I", "Generation II", "Generation III", "Generation IV", "Generation V", "Generation VI", "Generation VII", "Exit"]
    gen = nil
    while gen != "Exit"
      gen = prompt.select("\nWhich generation would you like to look at?", generation, per_page: 8, cycle: true)
      test = (genchoice = prompt.select("Please select your Pokemon", genquery , per_page: 30, cycle: true)
        pokequery = PokeApi.get(pokemon: genchoice)
        puts "\nID: " + "#{pokequery.id}" + " - " + pokequery.name.capitalize
        puts "Type: " + pokequery.types.map {|t| t.type.name.capitalize}.join(" & ")
        puts "\n"

        adddontadd = prompt.select("\nWould you like to add this pokemon to a party?", ["Yes", "No"], cycle: true)
        if adddontadd == "Yes"
          puts "Which team would you like to add this pokemon to?"
          teamsave = Team.find_or_create_by(name: gets.chomp)
          nickname = prompt.select("\nWould you like to give it a nickname?", ["Yes", "No"], cycle: true)
          if nickname == "Yes"
            nickname = gets.chomp
          else
            nickname = pokequery.name
          end
          newpokemon = Pokemon.create!(team: teamsave, species: pokequery.name, name: nickname)
          abilitychoice = prompt.select("\nWhich ability would you like to add to #{pokequery.name}", [pokequery.abilities.map {|t| t.ability.name}], cycle: true)
          Ability.create(pokemon:newpokemon, name:abilitychoice, description:PokeApi.get(ability: abilitychoice).effect_entries[0].short_effect)
        end)

      
        if gen == "Generation I" 
        limit = 151 
        offset = 0

      elsif gen == "Generation II"
        limit = 100
        offset = 151
        
      elsif gen == "Generation III"
        limit = 135
        offset = 251

      elsif gen == "Generation IV"
        limit = 107
        offset = 386
        
      elsif gen == "Generation V"
        limit = 156
        offset = 493
        
      elsif gen == "Generation VI"
        limit = 72
        offset = 649
        
      elsif gen == "Generation VII"
        limit = 86
        offset = 721
      end
    end