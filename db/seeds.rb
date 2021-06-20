minerals = Resource.find_or_create_by(name: 'minerals')
water = Resource.find_or_create_by(name: 'water')
food = Resource.find_or_create_by(name: 'food')

andvari = Planet.find_or_create_by(name: 'Andvari')
demeter = Planet.find_or_create_by(name: 'Demeter')
aqua = Planet.find_or_create_by(name: 'Aqua')
calas = Planet.find_or_create_by(name: 'Calas')

TravelRoute.find_or_create_by(origin: andvari, destiny: aqua, cost: 13)
TravelRoute.find_or_create_by(origin: andvari, destiny: calas, cost: 23)
TravelRoute.find_or_create_by(origin: demeter, destiny: aqua, cost: 22)
TravelRoute.find_or_create_by(origin: demeter, destiny: calas, cost: 25)
TravelRoute.find_or_create_by(origin: aqua, destiny: demeter, cost: 30)
TravelRoute.find_or_create_by(origin: aqua, destiny: calas, cost: 12)
TravelRoute.find_or_create_by(origin: calas, destiny: andvari, cost: 20)
TravelRoute.find_or_create_by(origin: calas, destiny: demeter, cost: 25)
TravelRoute.find_or_create_by(origin: calas, destiny: aqua, cost: 15)

thales = Pilot.find_or_create_by(certification: '6844690', name: 'Thales Augusto', age: 24, credits: 10,
                                 location: calas)
talysson = Pilot.find_or_create_by(certification: '5748306', name: 'Talysson de Oliveira', age: 22, credits: 20,
                                   location: aqua)
cassiano = Pilot.find_or_create_by(certification: '0045260', name: 'Cassiano', age: 23, credits: 35, location: andvari)

Ship.find_or_create_by(fuel_capacity: 50, fuel_level: 25, weight_capacity: 100, pilot: thales)
Ship.find_or_create_by(fuel_capacity: 70, fuel_level: 30, weight_capacity: 100, pilot: talysson)
Ship.find_or_create_by(fuel_capacity: 80, fuel_level: 15, weight_capacity: 100, pilot: cassiano)

Contract.find_or_create_by(payload: food, payload_weight: 10, origin: calas, destiny: aqua, value: 10, state: 'opened')
Contract.find_or_create_by(payload: minerals, payload_weight: 20, origin: aqua, destiny: demeter, value: 10,
                           state: 'processing', pilot: thales)
Contract.find_or_create_by(payload: water, payload_weight: 25, origin: andvari, destiny: demeter, value: 10,
                           state: 'finished', pilot: cassiano)
