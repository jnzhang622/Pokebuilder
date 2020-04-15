class CreateAbilities < ActiveRecord::Migration[6.0]
    def change
        create_table :abilities do |t|
            t.integer   :pokemon_id
            t.string    :name
            t.string    :description
        end
    end
end