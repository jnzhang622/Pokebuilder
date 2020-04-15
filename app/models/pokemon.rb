class Pokemon < ActiveRecord::Base
    belongs_to :team
    has_many :abilities
    has_many :helditems
    has_many :attacks

    # def view_pokemon_info
    #     puts "ID: " + "#{self.id}" + " - " + self.name.capitalize
    #     puts "Type: " + self.types.map {|t| t.type.name.capitalize}.join(" & ")
    # end

    # def pokequery
    #     PokeApi.get(pokemon: "self")
    # end

end