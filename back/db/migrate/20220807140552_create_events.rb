class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string   :name, null: false, unique: true
      t.string   :director
      t.datetime :start_term
      t.datetime :end_term

      t.timestamps
    end
  end
end
