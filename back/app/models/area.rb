class Area < ApplicationRecord
  # schema.rbから生成
  # t.string "name"
  # t.string "url"
  # t.datetime "created_at", precision: 6, null: false
  # t.datetime "updated_at", precision: 6, null: false
  #
  # 以下は自分で追加
  has_many :pzs
end
