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

  def tuition_invoice_export(tuition)
    teacher = tuition.teacher
    student = tuition.student
    profile = teacher.teacher_profile

    {
      invoice_number: "PT0#{tuition.id}",
      issue_date: Time.zone.today,
      student_name: export_blank(student.full_name),
      student_address: export_blank(''),
      phone: export_blank(student&.phone_number),
      tuition_for: "Học phí #{tuition.student.full_name}",
      amount: export_money(tuition.amount / 2),
      amount_number: tuition.amount / 2,
      account_name: export_blank(profile.bank_account_name),
      bank_name: export_blank(profile.bank_name),
      bank_account_number: export_blank(profile.bank_account_number)
    }
  end
end
