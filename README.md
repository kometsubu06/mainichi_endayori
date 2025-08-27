# まいにち園だより (mainichi-endayori)

## 📌 概要
保護者が毎日欠かさず確認できる「園だより」アプリです。  
子どもの不利益を防ぐことを目的に、紙ベースのやり取りをデジタル化し、  
**お知らせ・提出物・イベント参加可否・当日の体調報告** を一元管理できるようにします。

## 🎯 開発の目的
- 紙のお便り・提出物管理の負担を軽減  
- 保護者の記入忘れによる「子どもが参加できない」不利益をなくす  
- 園と家庭のコミュニケーションを効率化・記録化  

## 🛠️ 使用技術
- **Framework**: Ruby on Rails 7.1.0
- **Language**: Ruby 3.x
- **Database**: MySQL (PlanetScale)
- **Infrastructure**: Render
- **認証**: Devise (招待コード制)
- **テスト**: RSpec
- **その他**: dotenv-rails, rubocop, etc.

## ✨ MVP機能
- 招待コードでのユーザー登録・ログイン  
- お知らせの配信・既読管理（未読のみリマインド通知）  
- 提出依頼と提出状態（済/未）  
- イベント参加可否（RSVP）  
- 当日の体調報告・欠席/遅刻連絡  

### 招待コードの発行（ローカル）
Railsコンソールで以下を実行して code を控え、/invite で入力します。

Invitation.create!(code: SecureRandom.hex(6), expires_at: 3.days.from_now)
---

## 🗄️ データベース設計

### users テーブル
| Column             | Type    | Options                        |
|--------------------|---------|--------------------------------|
| email              | string  | null: false, unique: true       |
| encrypted_password | string  | null: false                     |
| name               | string  | null: false                     |
| role               | integer | default: 0, null: false         |
| organization_id    | bigint  | foreign_key                     |

**Association**
- belongs_to :organization
- has_many :guardianships
- has_many :children, through: :guardianships
- has_many :notice_reads
- has_many :submissions
- has_many :event_responses
- has_many :daily_reports

---

### children テーブル
| Column          | Type   | Options          |
|-----------------|--------|------------------|
| name            | string | null: false      |
| organization_id | bigint | foreign_key      |
| classroom_id    | bigint | foreign_key      |

**Association**
- belongs_to :organization
- has_many :guardianships
- has_many :users, through: :guardianships
- has_many :submissions
- has_many :event_responses
- has_many :daily_reports

---

### guardianships テーブル
| Column       | Type   | Options                      |
|--------------|--------|------------------------------|
| user_id      | bigint | null: false, foreign_key     |
| child_id     | bigint | null: false, foreign_key     |
| relationship | string | null: false                  |

**Association**
- belongs_to :user
- belongs_to :child

---

### notices テーブル
| Column          | Type    | Options                         |
|-----------------|---------|---------------------------------|
| title           | string  | null: false                     |
| body            | text    |                                 |
| due_on          | date    |                                 |
| category        | integer | default: 0, null: false         |
| status          | integer | default: 0, null: false         |
| organization_id | bigint  | foreign_key                     |

**Association**
- belongs_to :organization
- has_many :notice_reads

---

### notice_reads テーブル
| Column    | Type     | Options                      |
|-----------|----------|------------------------------|
| notice_id | bigint   | null: false, foreign_key     |
| user_id   | bigint   | null: false, foreign_key     |
| read_at   | datetime |                              |

**Association**
- belongs_to :notice
- belongs_to :user

---

### submission_requests テーブル
| Column          | Type    | Options          |
|-----------------|---------|------------------|
| title           | string  | null: false      |
| description     | text    |                  |
| due_on          | date    |                  |
| status          | integer | default: 0       |
| organization_id | bigint  | foreign_key      |

**Association**
- belongs_to :organization
- has_many :submissions

---

### submissions テーブル
| Column                 | Type     | Options                      |
|------------------------|----------|------------------------------|
| submission_request_id  | bigint   | null: false, foreign_key     |
| child_id               | bigint   | null: false, foreign_key     |
| submitted_by           | bigint   | foreign_key                  |
| submitted_at           | datetime |                              |
| status                 | integer  | default: 0                   |

**Association**
- belongs_to :submission_request
- belongs_to :child
- belongs_to :user, foreign_key: :submitted_by

---

### events テーブル
| Column          | Type    | Options          |
|-----------------|---------|------------------|
| title           | string  | null: false      |
| description     | text    |                  |
| due_on          | date    |                  |
| place           | string  |                  |
| organization_id | bigint  | foreign_key      |

**Association**
- belongs_to :organization
- has_many :event_responses

---

### event_responses テーブル
| Column      | Type     | Options                     |
|-------------|----------|-----------------------------|
| event_id    | bigint   | null: false, foreign_key    |
| child_id    | bigint   | null: false, foreign_key    |
| responded_by| bigint   | foreign_key                 |
| responded_at| datetime |                             |
| status      | integer  | default: 0                  |

**Association**
- belongs_to :event
- belongs_to :child
- belongs_to :user, foreign_key: :responded_by

---

### daily_reports テーブル
| Column       | Type     | Options                      |
|--------------|----------|------------------------------|
| child_id     | bigint   | null: false, foreign_key     |
| date         | date     | null: false                  |
| temperature  | decimal  | precision: 4, scale: 1       |
| symptoms     | text     |                              |
| attendance   | integer  | default: 0                   |
| submitted_by | bigint   | foreign_key                  |
| submitted_at | datetime |                              |

**Association**
- belongs_to :child
- belongs_to :user, foreign_key: :submitted_by

---