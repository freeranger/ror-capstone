FactoryGirl.define do

  factory :thing_tag do

    tag { Faker::Lorem.word }

  #  after(:build) do |link|
   #   pp :thing_tag
   #   link.tags << (:thing_tag)
  #  end
  end

end
