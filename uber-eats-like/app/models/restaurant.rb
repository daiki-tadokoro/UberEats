class Restaurant < ApplicationRecord
  has_many :foods
  has_many :line_foods, through: :foods

  # データが必ず存在する(存在しないとエラーになる)ことを定義
  validates :name, :fee, :time_required, presence: true
  # :nameが最大30文字以下と制限
  DEFAULT_NAME_LENGTH = 30
  validates :name, length: { maximum: DEFAULT_NAME_LENGTH }
  # 手数料が0以上であることと制限
  validates :fee, numericality: { greater_than: 0 }
end
