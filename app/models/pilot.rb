class Pilot < ApplicationRecord
  belongs_to :location, class_name: "Planet"
end
