# テスト用招待コード
Invitation.create!(
  code: "test1234",                # 任意の招待コード（英数字でOK）
  email: "test@example.com",       # 任意（空でも可）
  role: 0,                         # guardian など enum 定義があればその値
  expires_at: 7.days.from_now      # 期限：1週間後
)