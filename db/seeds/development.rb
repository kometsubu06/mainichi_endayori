# 園を用意
org = Organization.find_or_create_by!(name: "デモ園")

# 保護者ユーザーを作成
user = User.find_or_create_by!(email: "test@example.com") do |u|
  u.name = "テスト保護者"
  u.password = "password"
  u.role = :guardian if u.respond_to?(:role)
  u.organization = org
end

# 子どもを作成
child = Child.find_or_create_by!(name: "たろう", organization: org) do |c|
  #c.classroom_id = Classroom.first&.id  # classroom 必須なら設定（任意）
end

# 保護者と子どもの紐付け（guardianship）
Guardianship.find_or_create_by!(user: user, child: child) do |g|
  g.relationship = "父"  # or "母"など
end

# 既読を一掃
NoticeRead.delete_all
AuditLog.where(action: 'notice.read').delete_all

# お知らせ
notices = [
  { title: "プールについて", body: "本日はプール実施予定です。持ち物：タオル、着替え。", require_submission: false, published_at: 1.day.ago },
  { title: "遠足のしおり配布", body: "提出物：同意書を締切までに提出してください。", require_submission: true,  published_at: Time.current, due_on: Date.today + 7 },
  { title: "保護者会のご案内", body: "来週土曜 10時〜 園ホールにて。",                            require_submission: false, published_at: Time.current }
]

notices.each do |attrs|
  Notice.create!(attrs.merge(organization: org, status: 0))
end

puts "✅ Seed completed: org/user/child/guardianship/notices created"