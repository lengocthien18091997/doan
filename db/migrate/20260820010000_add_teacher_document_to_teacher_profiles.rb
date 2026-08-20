class AddTeacherDocumentToTeacherProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :teacher_profiles, :document_path, :string
    add_column :teacher_profiles, :document_filename, :string
  end
end