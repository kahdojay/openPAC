class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :bill_id
      t.string :official_title, null: false
      t.string :popular_title
      t.string :short_title
      t.string :summary
      t.string :summary_short
      t.string :congress_url
      t.references :issue
    end
  end
end
