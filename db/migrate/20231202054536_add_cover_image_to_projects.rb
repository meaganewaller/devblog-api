class AddCoverImageToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :cover_image, :string
  end
end
