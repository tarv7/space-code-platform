class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.references :reportable, null: false, polymorphic: true
      t.string :action,         null: false
      t.string :value,          null: false

      t.timestamps
    end
  end
end
