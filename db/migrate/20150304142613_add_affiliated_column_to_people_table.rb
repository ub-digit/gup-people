class AddAffiliatedColumnToPeopleTable < ActiveRecord::Migration
  def change
    add_column :people, :affiliated, :boolean, :default => false
  end
end
