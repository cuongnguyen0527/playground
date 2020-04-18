class CreateStaffs < ActiveRecord::Migration[6.0]
  def change
    create_table :staffs do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.integer :point

      t.timestamps
    end
  end
end
