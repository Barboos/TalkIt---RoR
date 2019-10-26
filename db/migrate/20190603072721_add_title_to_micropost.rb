class AddTitleToMicropost < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :title, :text
  end
end
