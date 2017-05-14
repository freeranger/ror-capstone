class ThingTag < ActiveRecord::Base
  belongs_to :thing

  validates :thing, presence: true
  
end
