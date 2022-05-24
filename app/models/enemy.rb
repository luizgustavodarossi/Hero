class Enemy < ApplicationRecord
  enum kind: %i[goblin orc demon dragon troll]
  validates :level, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 99 }
  validates_presence_of :name, :kind, :level, :power_base, :power_step

  def current_power
    power_base + (level - 1) * power_step
  end
end
