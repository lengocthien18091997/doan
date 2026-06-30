puts "Seeding data..."

# Xóa dữ liệu cũ (nếu có)
User.destroy_all
TeacherProfile.destroy_all
Request.destroy_all
Timetable.destroy_all
Support.destroy_all

# ========================
# 1️⃣  TẠO USER
# ========================
admin = User.create!(
    full_name: "Admin System",
    email: "admin@example.com",
    password: "123456",
    role: "admin",
    is_locked: false,
    phone_number: "0909000000",
    gender: "other",
    date_of_birth: "1990-01-01"
)

teacher1 = User.create!(
    full_name: "Nguyen Van A",
    email: "teacher1@example.com",
    password: "123456",
    role: "teacher",
    is_locked: false,
    phone_number: "0909000001",
    gender: "male",
    date_of_birth: "1995-05-10"
)

teacher2 = User.create!(
    full_name: "Tran Thi B",
    email: "teacher2@example.com",
    password: "123456",
    role: "teacher",
    is_locked: false,
    phone_number: "0909000002",
    gender: "female",
    date_of_birth: "1996-06-15"
)

student1 = User.create!(
    full_name: "Le Minh C",
    email: "student1@example.com",
    password: "123456",
    role: "student",
    is_locked: false,
    phone_number: "0909000003",
    gender: "male",
    date_of_birth: "2005-03-12"
)

student2 = User.create!(
    full_name: "Pham Thi D",
    email: "student2@example.com",
    password: "123456",
    role: "student",
    is_locked: false,
    phone_number: "0909000004",
    gender: "female",
    date_of_birth: "2006-07-22"
)

puts "✅ Created Users"

# ========================
# 2️⃣  TẠO TEACHER PROFILE
# ========================
TeacherProfile.create!(
    user: teacher1,
    bio: "Tôi có 5 năm kinh nghiệm dạy Toán và Lý cấp 3.",
    education_level: "Đại học Sư phạm",
    experience_years: 5,
    hourly_rate: 150000,
    location: "Hà Nội",
    subjects: { "Toán" => "Cấp 1", "Lý" => "Cấp 2" },
    availability: { 2 => 18, 7 => 8 }
)

TeacherProfile.create!(
    user: teacher2,
    bio: "Gia sư tiếng Anh giao tiếp, luyện thi IELTS.",
    education_level: "Cử nhân Ngôn ngữ Anh",
    experience_years: 3,
    hourly_rate: 200000,
    location: "TP.HCM",
    subjects: { "Toán" => "Cấp 1", "Lý" => "Cấp 2" },
    availability: { 2 => 18, 7 => 8 }
)

puts "✅ Created Teacher Profiles"

# ========================
# 3️⃣  TẠO REQUEST
# ========================
request1 = Request.create!(
    student: student1,
    teacher: teacher1,
    subject: "Toán 12",
    grade_level: "12",
    requirement_detail: "Cần ôn thi tốt nghiệp gấp",
    budget: 150000,
    location: "Hà Nội",
    schedule: { 2 => 18, 7 => 8 },
    status: "open"
)

request2 = Request.create!(
    student: student2,
    teacher: teacher2,
    subject: "Tiếng Anh IELTS",
    grade_level: "11",
    requirement_detail: "Mục tiêu IELTS 6.5",
    budget: 250000,
    location: "TP.HCM",
    schedule: { 2 => 18, 7 => 8 },
    status: "accepted"
)

puts "✅ Created Requests"

# ========================
# 4️⃣  TẠO TIMETABLE
# ========================
Timetable.create!(
    teacher: teacher1,
    student: student1,
    subject: "Toán 12",
    schedule: { 2 => 18, 7 => 8 },
    status: "open"
)

Timetable.create!(
    teacher: teacher2,
    student: student2,
    subject: "Tiếng Anh IELTS",
    schedule: { 2 => 18, 7 => 8 },
    status: "open"
)

puts "✅ Created Timetables"

# ========================
# 5️⃣  TẠO SUPPORT
# ========================
Support.create!(
    user: student1,
    category: "account",
    comment: "Không đăng nhập được vào hệ thống",
    status: "open"
)

Support.create!(
    user: teacher2,
    category: "payment",
    comment: "Tôi chưa nhận được thanh toán cho buổi dạy hôm qua",
    status: "processing"
)

puts "✅ Created Supports"

puts "🎉 Seeding completed successfully!"
