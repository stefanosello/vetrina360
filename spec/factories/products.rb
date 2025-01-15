FactoryBot.define do
  factory :product do
    description { Faker::Commerce.product_name }
    additional_description { Faker::Marketing.buzzwords }
    model { Faker::Commerce.promotion_code }
  end
end
