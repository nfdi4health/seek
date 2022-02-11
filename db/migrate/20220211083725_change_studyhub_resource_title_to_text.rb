class ChangeStudyhubResourceTitleToText < ActiveRecord::Migration[5.2]
  def up
    change_column :studyhub_resources,:title,:text
  end

  def down
    change_column :studyhub_resources,:title,:string
  end
end
