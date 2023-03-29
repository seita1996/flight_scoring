class CreateAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :areas do |t|
      t.string :name, null: false, unique: true
      t.string :url

      t.timestamps
    end
  end
end
