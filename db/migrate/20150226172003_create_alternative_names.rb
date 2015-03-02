class CreateAlternativeNames < ActiveRecord::Migration
  def change
    create_table :alternative_names do |t|
      t.belongs_to :person, index: true
      t.text :first_name
      t.text :last_name

      t.timestamps null: false
    end
  end
end
