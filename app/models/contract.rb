class Contract < ApplicationRecord
  belongs_to :pilot
  belongs_to :payload, class_name: "Resource"
  belongs_to :origin, class_name: "Planet"
  belongs_to :destiny, class_name: "Planet"
end
