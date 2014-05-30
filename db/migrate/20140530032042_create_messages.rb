class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :client
      t.string :message_id
      t.string :message_description
      t.string :message_type
      t.integer :message_severity
      t.string :attribute1
      t.string :attribute2
      t.string :attribute3
      t.string :attribute4
      t.string :attribute5
      t.string :attribute6
      t.string :attribute7
      t.string :attribute8
      t.string :attribute9
      t.string :attribute10
      t.datetime :update_date
      t.string :updated_user
      t.string :updated_prc

      t.timestamps
    end
  end
end
