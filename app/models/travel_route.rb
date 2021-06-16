class TravelRoute < ApplicationRecord
  belongs_to :origin, class_name: "Planet"
  belongs_to :destiny, class_name: "Planet"
end
