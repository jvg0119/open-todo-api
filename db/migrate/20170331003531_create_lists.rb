class CreateLists < ActiveRecord::Migration[5.0]
  def change
    create_table :lists do |t|
      t.string :name
      t.integer :permission
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
