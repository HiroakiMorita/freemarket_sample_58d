# freemarket_sample_58d DB設計
## usersテーブル
|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false|
|email|string|null: false, unique: true|
|password|string|null: false|
### Association
- has_one :credit_card
- has_one :profile
- has_many :items
- has_many :comments
- has_many :sns_credentials, dependent: :destroy

## credit_cardsテーブル
|Column|Type|Options|
|------|----|-------|
|number|integer|null: false|
|limit_year|integer|null: false|
|limit_month|integer|null: false|
|security_code|integer|null: false|
|user_id|references|null: false, foreign_key: true|
### Association
- belongs_to :user

## profilesテーブル
|Column|Type|Options|
|------|----|-------|
|family_name_kanji|string|null: false|
|first_name_kanji|string|null: false|
|family_name_kana|string|null: false|
|first_name_kana|string|null: false|
|birth_year|date|null: false|
|birth_month|date|null: false|
|birth_day|date|null: false|
|phone_number|string|null: false, unique: true|
|message|text||
|evaluation_good|integer|null: false|
|evaluation_normal|integer|null: false|
|evaluation_bad|integer|null: false|
|user_id|references|null: false, foreign_key: true|
### Association
- belongs_to :user

<!-- 発送元・配送先 -->
## addressテーブル
|Column|Type|Options|
|------|----|-------|
|postal_code|integer|null: false|
|prefecture_id|references|null: false, foreign_key: true| <!-- 都道府県、アクティブハッシュとの関連付け -->
|city|string|null: false|
|house_number|string|null: false|
|building|string||
|user_id|references|null: false, foreign_key: true|
### Association
- belongs_to :user
- belongs_to :prefecture  <!-- アクティブハッシュ専用の記述にする -->

<!-- 都道府県 についてはアクティブハッシュで実装-->
<!-- ## prefecturesテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
### Association
- has_many: addresses
- has_many: items -->

<!-- Facebook等のSNS認証用 -->
## sns_credentialsテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|references|null: false, foreign_key: true|
|uid|string||
|provider|string||
### Association
- belongs_to :user

## itemsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, index: true|
|price|integer|null: false, index: true|
|explanation|text|null: false| <!-- 商品の説明 -->
|user_id|references|null: false, foreign_key: true|
|category_id|references|null: false, foreign_key: true|
|brand_id|references|foreign_key: true|
|size|integer||
|state|integer|null: false| <!-- 商品の状態 -->
|postage|integer|null: false| <!-- 配送料 -->
|shipping_method|integer|null: false| <!-- 配送の方法 -->

|prefecture_id|references|null: false, foreign_key: true | <!-- 発送元の地域(元region)、アクティブハッシュとの関連付け -->

|shipping_date|integer|null: false| <!-- 発送までの日数 -->
|business_status|integer|null: false| <!-- 取引の状態(販売中、売却済など) -->
|buyer_id|references|foreign_key: true| <!-- 購入者 -->
### Association
- belongs_to :user
- belongs_to :category
- belongs_to :brand
- has_many :item_images
- has_many :comments

<!-- 1つのitemに対して複数のimageが設定できてしまうため -->
## item_imagesテーブル
|Column|Type|Options|
|------|----|-------|
|image|text|null: false|
|item_id|references|null: false, foreign_key: true|
### Association
- belongs_to: item

<!-- ancestoryでツリー構造を実装 -->
## categorysテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestory|string||
### Association
- has_many :items
- has_ancestory

## brandsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
### Association
- has_many :items

<!-- 商品詳細ページのコメント -->
## commentsテーブル
|Column|Type|Options|
|------|----|-------|
|comment|text||
|user_id|references|null: false, foreign_key: true|
|item_id|references|null: false, foreign_key: true|
### Association
- belongs_to :user
- belongs_to :item
