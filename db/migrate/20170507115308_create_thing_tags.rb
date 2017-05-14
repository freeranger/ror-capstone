class CreateThingTags < ActiveRecord::Migration
  def change
    create_table :thing_tags do |t|
      t.references :thing, { index: true, foreign_key: true, null: false}
      t.string :tag, { index: true, null: false }
    end

    add_index :thing_tags,  [:thing_id, :tag], unique: true
  end
end
