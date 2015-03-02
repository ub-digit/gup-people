class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.integer :year_of_birth
      t.text :first_name
      t.text :last_name

      t.timestamps null: false
    end
  end
end
