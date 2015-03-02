class CreateIdentifiers < ActiveRecord::Migration
  def change
    create_table :identifiers do |t|
      t.belongs_to :person, index: true
      t.belongs_to :source, index: true
      t.text :value

      t.timestamps null: false
    end
  end
end
