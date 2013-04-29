FactoryGirl.define do
  # Model.build(:model, :id) to get fake ID
  trait :id do
    id { rand(1000000) }
  end

  # attribute { generate(:random_string) }
  sequence :random_string do |n|
    rand(10**10).to_s
  end
end
