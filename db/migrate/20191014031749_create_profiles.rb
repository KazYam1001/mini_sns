class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :birthday, null: false
      t.string :phone_number, null: false
      t.string :postal_code, null: false
      t.string :city, null: false
      t.string :block, null: false
      t.string :building
      t.text :introduction
      t.string :avatar
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
