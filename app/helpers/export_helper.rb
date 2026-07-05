module ExportHelper
  include ActionView::Helpers::NumberHelper

  def export_blank(value = nil)
    value.present? ? value : "................................"
  end

  def export_money(value)
    return export_blank if value.blank?

    number_to_currency(value, unit: "VNĐ", delimiter: ".", separator: ",", precision: 0, format: "%n %u")
  end

  def contract_confirmed_text(value)
    value ? "Đã xác nhận" : "Chưa xác nhận"
  end

  def teacher_registration_export(user)
    profile = user.teacher_profile

    {
      full_name: export_blank(user.full_name),
      phone: user.phone_number,
      email: user.email,
      address:  profile&.location,
      bio: export_blank(profile&.bio),
      education_level: export_blank(profile&.education_level),
      experience_years: export_blank(profile&.experience_years),
      location: export_blank(profile&.location),
      offer: export_money(profile&.hourly_rate),
      bank_name: export_blank(profile&.bank_name),
      bank_code: export_blank(profile&.bank_code),
      bank_account_number: export_blank(profile&.bank_account_number),
      bank_account_name: export_blank(profile&.bank_account_name),
      export_day: Time.zone.today
    }
  end

  def teacher_contract_export(user)
    profile = user.teacher_profile

    {
      contract_number: "HD0#{user.id}",
      full_name: export_blank(user.full_name),
      education_level: export_blank(profile&.education_level),
      location: export_blank(profile&.location),
      export_day: Time.zone.today,
      company_representative: "Lê Ngọc Thiện",
      company_representative_title: "Giám đốc"
    }
  end
end
