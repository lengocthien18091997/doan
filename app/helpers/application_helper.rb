module ApplicationHelper
  def avatar_initials(user)
    name = user&.full_name.to_s.strip
    return "U" if name.blank?

    words = name.split(/\s+/)
    initials = words.first(2).map { |word| word[0] }.join
    initials.presence || "U"
  end

  def dashboard_title_for(role)
    {
      "student" => "VnEdu for Student",
      "teacher" => "VnEdu for Teacher",
      "admin" => "VnEdu for Admin"
    }.fetch(role.to_s, "VnEdu for Student")
  end

  def ui_icon(name, options = {})
    size = options.fetch(:size, 22)
    klass = options[:class]
    paths = {
      dashboard: '<path d="M3 10.5 12 3l9 7.5"/><path d="M5 10v9h5v-5h4v5h5v-9"/>',
      courses: '<path d="M6 4h12a2 2 0 0 1 2 2v13H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2Z"/><path d="M8 8h8M8 12h6"/>',
      tutors: '<circle cx="9" cy="8" r="3"/><path d="M3.5 20a5.5 5.5 0 0 1 11 0"/><circle cx="17" cy="9" r="2"/><path d="M15.5 16.5a4 4 0 0 1 5 3.5"/>',
      schedule: '<rect x="4" y="5" width="16" height="15" rx="2"/><path d="M8 3v4M16 3v4M4 10h16"/><path d="m9 15 2 2 4-4"/>',
      payments: '<rect x="3" y="6" width="18" height="13" rx="2"/><path d="M3 10h18"/><circle cx="17" cy="15" r="1.5"/>',
      reviews: '<path d="m12 3 2.8 5.7 6.2.9-4.5 4.4 1.1 6.2L12 17.3l-5.6 2.9 1.1-6.2L3 9.6l6.2-.9L12 3Z"/>',
      user: '<circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/>',
      user_plus: '<circle cx="9" cy="8" r="4"/><path d="M3 21a7 7 0 0 1 12 0"/><path d="M19 8v6M16 11h6"/>',
      lock: '<rect x="5" y="10" width="14" height="10" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/>',
      book: '<path d="M5 4h11a3 3 0 0 1 3 3v13H8a3 3 0 0 1-3-3V4Z"/><path d="M8 8h7M8 12h6"/>',
      invite: '<path d="M5 5h14v10H7l-4 4V7a2 2 0 0 1 2-2Z"/><path d="M9 9h6M9 12h4"/>',
      money: '<rect x="4" y="6" width="16" height="12" rx="2"/><path d="M8 10h8M8 14h5"/><path d="M17 14h.01"/>',
      star: '<path d="m12 3 2.8 5.7 6.2.9-4.5 4.4 1.1 6.2L12 17.3l-5.6 2.9 1.1-6.2L3 9.6l6.2-.9L12 3Z"/>',
      profile: '<circle cx="12" cy="8" r="4"/><path d="M5 21a7 7 0 0 1 14 0"/>',
      logout: '<path d="M10 17l5-5-5-5"/><path d="M15 12H3"/><path d="M21 4v16"/>',
      chevron: '<path d="m6 9 6 6 6-6"/>'
    }

    content_tag(
      :svg,
      paths.fetch(name.to_sym, paths[:dashboard]).html_safe,
      xmlns: "http://www.w3.org/2000/svg",
      width: size,
      height: size,
      viewBox: "0 0 24 24",
      fill: "none",
      stroke: "currentColor",
      "stroke-width": 2,
      "stroke-linecap": "round",
      "stroke-linejoin": "round",
      class: klass
    )
  end
end
