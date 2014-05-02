FactoryGirl.define do

  factory :business do
    sequence(:name) {|n| "Business #{n}" }
    sequence(:website) {|n| "http://business#{n}.com" }
  end

end