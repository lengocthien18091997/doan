module UserHelper

  # def params_update
  #   params.require(:user).permit(
  #       :full_name, :email, :phone_number, :gender, :date_of_birth, :is_locked,
  #       teacher_profile_attributes: [
  #           :bio, :education_level, :experience_years, :location, :hourly_rate,
  #           subjects: {},
  #           availability: {}
  #       ]
  #   )
  # end

  def params_update
    p = params.require(:user).permit(
        :full_name, :email, :phone_number, :gender, :date_of_birth, :is_locked, :password,
        teacher_profile_attributes: [
            :bio, :education_level, :experience_years, :location, :hourly_rate, :bank_name, :bank_code, :bank_account_number, :bank_account_name,
            subjects: {}, availability: {}
        ]
    )

    if p[:teacher_profile_attributes] && p[:teacher_profile_attributes][:subjects]
      p[:teacher_profile_attributes][:subjects] = p[:teacher_profile_attributes][:subjects].transform_keys { |k| k.to_s.gsub('_', ' ') }
      p[:teacher_profile_attributes][:availability] = p[:teacher_profile_attributes][:availability].transform_keys { |k| k.to_s.gsub('_', ' ') }
    end

    p
  end


  def tinh_cap_hoc(date)
    return 'Cấp 3' if date.nil?
    tuoi = Time.now.year - date.year
    case tuoi
    when 0..11
      'Cấp 1'
    when 12..15
      'Cấp 2'
    else
      'Cấp 3'
    end
  end
end
