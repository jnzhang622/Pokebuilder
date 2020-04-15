class CreateHelditems < ActiveRecord::Migration[6.0]
    def change
        create_table :helditems do |t|
            t.integer   :pokemon_id
            t.string    :name
            t.string    :description
        end
    end
end