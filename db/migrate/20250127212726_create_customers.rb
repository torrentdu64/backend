class CreateCustomers < ActiveRecord::Migration[7.2]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :gender
      t.string :ip_address
      t.string :company
      t.string :city
      t.string :title
      t.string :website

      t.timestamps
    end
  end
end
