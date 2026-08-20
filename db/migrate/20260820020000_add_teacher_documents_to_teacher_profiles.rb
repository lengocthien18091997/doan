class AddTeacherDocumentsToTeacherProfiles < ActiveRecord::Migration[7.0]
  def up
    add_column :teacher_profiles, :documents, :jsonb, default: [], null: false

    TeacherProfile.reset_column_information
    TeacherProfile.find_each do |profile|
      next if profile.document_path.blank?

      profile.update_columns(
        documents: [{ "path" => profile.document_path, "filename" => profile.document_filename }]
      )
    end
  end

  def down
    remove_column :teacher_profiles, :documents
  end
end