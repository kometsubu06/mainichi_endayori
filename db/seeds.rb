# テスト用招待コード
Invitation.find_or_create_by!(code: "test1234") do |inv|
  inv.email = "test@example.com"
  inv.role = 0
  inv.expires_at = 30.days.from_now
  inv.used_at = nil
end

puts "✅ 招待コード test1234 を作成しました"