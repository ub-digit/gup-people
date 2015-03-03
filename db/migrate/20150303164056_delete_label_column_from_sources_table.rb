class DeleteLabelColumnFromSourcesTable < ActiveRecord::Migration
  def change
    remove_column :sources, :label
  end
end
