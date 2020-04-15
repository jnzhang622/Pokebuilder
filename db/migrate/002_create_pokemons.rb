class CreatePokemons < ActiveRecord::Migration[6.0]
    def change
        create_table :pokemons do |t|
            t.integer   :team_id
            t.string    :species
            t.string    :name
        end
    end
end