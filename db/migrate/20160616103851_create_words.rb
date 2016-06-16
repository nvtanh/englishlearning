class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :name, default: ""
      t.string :pronunciation, default: ""
      t.string :categorie, default: ""
      t.string :eng_define, default: ""
      t.string :vi_define, default: ""
      t.text :examples, array: true

      t.timestamps null: false
    end
  end
end
