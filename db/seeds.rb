# デモ園
org = Organization.find_or_create_by!(name: "デモ園")

# 管理者ユーザー
User.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = "password"
  u.name = "テスト管理者"
  u.role = :admin
  u.organization = org
end

# 保護者ユーザー
guardian = User.find_or_create_by!(email: "guardian@example.com") do |u|
  u.password = "password"
  u.name = "テスト保護者"
  u.role = :guardian
  u.organization = org
end

# 子ども & 紐づけ
child = Child.find_or_create_by!(name: "テスト太郎", organization: org)
Guardianship.find_or_create_by!(user_id: guardian.id, child_id: child.id) do |g|
  g.relationship = "保護者"
end