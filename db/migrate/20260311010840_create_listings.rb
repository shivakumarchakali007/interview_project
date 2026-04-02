class CreateListings < ActiveRecord::Migration[8.1]
  def change
    create_table :listings do |t|
      t.string :title
      t.string :description
      t.integer :listing_number
      t.integer :listing_price
      t.string :hubspot_deal_id
      t.string :string

      t.timestamps
    end
  end
end
