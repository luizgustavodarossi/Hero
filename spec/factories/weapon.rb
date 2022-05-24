require 'ffaker'

FactoryBot.define do
  factory :weapon do
    name { %w[excalibur lance war_axe dagger bow crossbow magic_staff wand staff sword].sample }
    description { FFaker::Lorem.paragraph }
    power_step { FFaker::Random.rand(1..500) }
    power_base { FFaker::Random.rand(1..500) }
    level { FFaker::Random.rand(1..99) }
  end
end
