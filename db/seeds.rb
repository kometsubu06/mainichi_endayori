# テスト用招待コード
Invitation.find_or_create_by!(code: "test1234") do |inv|
  inv.email = "test@example.com"
  inv.role = 0
  inv.expires_at = 7.days.from_now
end