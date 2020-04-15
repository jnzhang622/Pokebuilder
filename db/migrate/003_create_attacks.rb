class CreateAttacks < ActiveRecord::Migration[6.0]
    def change
        create_table :attacks do |t|
            t.integer   :pokemon_id
            t.string    :name
            t.string    :atk_type
            t.integer   :power
            t.string    :description
        end
    end
end