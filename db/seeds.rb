# テスト用招待コード
Invitation.find_or_create_by!(code: "test1234") do |inv|
  inv.email = "test@example.com"
  inv.role = 0
  inv.expires_at = 30.days.from_now
  inv.used_at = nil
end

puts "✅ 招待コード test1234 を作成しました"

# ダミーデータ
if Notice.count.zero?
  Notice.create!([
    { title: "プールについて", body: "本日はプール実施予定です。持ち物：タオル、着替え。", require_submission: false, published_at: 1.day.ago },
    { title: "遠足のしおり配布", body: "提出物：同意書を締切までに提出してください。", require_submission: true, published_at: Time.current, due_on: Date.today + 7 },
    { title: "保護者会のご案内", body: "来週土曜 10時〜 園ホールにて。", require_submission: false, published_at: Time.current }
  ])
  puts "✅ Notice seed inserted"
end