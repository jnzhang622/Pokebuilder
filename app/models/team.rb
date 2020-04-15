class Team < ActiveRecord::Base
    has_many :pokemons
    has_many :helditems, through: :pokemons
    has_many :abilities, through: :pokemons
    has_many :attacks, through: :pokemons

    # def my_pokemon_attacks
    #     self.pokemons.map {|p| p.attacks}
    # end



end
