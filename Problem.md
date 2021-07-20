# Problem Description

You're the newest engineer charged for this job by the Intergalactic Federation. Your job is to build an application to manage the transport fleet of goods through the galaxy, including four planets.

## Requirements

You will develop an API, which will manage information about the pilots, ships, contracts as well as the cargos they transport.

To get that done, you will need to implement the following features:

### 1. Add pilots and their ships to the system.
[See attributes descriptions section](#attributes-descriptions)
### 2. Publish transport contracts
[See attributes descriptions section](#attributes-descriptions)
### 3. Travel between planets
Pilots can travel freely through the galaxy, respecting the limitations of the ship and blocked routes. [See the travels section](#travels).
### 4. List open contracts
[See attributes descriptions section](#attributes-descriptions)
### 5. Accept transport contracts
[See attributes descriptions section](#attributes-descriptions)
### 6. Grant credits to the pilot after fulfilling the contract 
The system must finish the contract when the pilot gets to the delivery destination. After that, the pilot receives the number of credits specified as value.
### 7. Register a refill of the fuel
You can register a refill when the ship is on any planet. A fuel unit costs 7 credits. 

### 8. Reports

As a government system, they want to know what's going on. They required you to make some reports:

* 8.1. Total weight in tons of each resource sent and received by each planet.

```json
[
  {...},
  "calas": {
    "sent": {
      "food": 140,
      "minerals": 10,
      "water": 5
    },
    "received": {
	    ...
    }
  },
  {...}
]
```

* 8.2. Percentage of resource type transported by each pilot.

```json
[
  {...},
  "pilot 2": {
    "food": 35,
    "water": 65
  },
  {...},
]
```

* 8.3. Intergalactic Federation transactions ledger sorted by date (oldest to newest).

```json
[
  "…",
  "Contract 2 Description paid: -₭936",
  "Contract 3 Description paid: -₭1200",
  "Han Solo bought fuel: +₭210",
  "…",
]
```

## Travels

Travel between planets has different distances and durations, reflecting on fuel consumption for each route. The table below shows these fuel costs.

|         	|         	|    To   	|      	|       	|
|---------	|:--------:	|:--------:	|:----:	|:------:	|
| From    	| Andvari 	| Demeter 	| Aqua 	| Calas 	|
| Andvari 	|    -    	|    X    	|  13  	|   23  	|
| Demeter 	|    X    	|    -    	|  22  	|   25  	|
| Aqua    	|    X    	|    30   	|   -  	|   12  	|
| Calas   	|    20   	|    25   	|  15  	|   -   	|

This table shows the X means the route between those planets is blocked by problems like an asteroid belt or a scrapyard. Please note that the route can be blocked from A to B while still open from B to A. As example follows:

Travel from Aqua to Andvari is not possible. But starting from Aqua is possible to travel to Calas using just 12 fuel units.

The _user_ of the system is responsible for making each travel between planets, but the system should validate if every travel is valid, as well as taking into account the effects of each travel in the database.

## Attributes descriptions

### Pilot
- pilot certification: the identification document permission to fly a ship. It uses Luhn validation similar to Brazilian CPF, composed by 6 digits and 1 check digit. Validation is optional.
- name: the pilot name.
- age: the pilot age. The minimum age to ride a ship is 18 years.
- credits: amount of credits owned by the pilot. It’s money, be aware.
- location planet: name the current planet where the fly is.

### Ship
- fuel capacity: ships have a maximum capacity of fuel they can hold.
- fuel level: current fuel level of the ship.  
- weight capacity: ships have a maximum of tons they can handle (considering just the cargo) 

### Contracts
- description: a description of what that contract is for. (e.g water and food to calas)
- payload: the actual cargo to be transported. Resources are listed here.
- origin planet: planet where the container should be taken.
- destination planet: planet where the pilot should take the container
- value: quantity of credits offered as payment for the contract

### Resource
- name: the name of the resource. The possible values are minerals, water or food.
- weight: how many tons of that resource.

## Notes

1. Please use one of the following languages/frameworks: *Ruby (Rails)*, *Javascript or TypeScript (Express, Fastify, Nest, Adonis)*, *Elixir (Phoenix)*, *Java or Kotlin (Spring, Seam)*, *Scala (Akka)* - listed in descending order of desirability. It's also possible to implement a solution using *Python (Django)*, *PHP (Laravel)*, but if you want to do so, please notify us in advance.
2. No authentication is required, your DNA are your credentials.
3. We still care about proper programming and architecture techniques; you must showcase that you're worthy of knowing that much of the system through the sheer strength of your skills;
4. It is expected that you use some database to persist the state of the application;
5. Don't forget to make at least a minimal documentation of the API endpoints or schema and how to use them;
6. Just to be clear: tests (unit, acceptance) are REQUIRED;
7. At least one integration, end-to-end, test should be included to represent a whole flow of using the application;
8. From the problem described above, you can either do a very bare-bones solution or add optional features that are not described. Use your time wisely. So it would be best if you came up with the best possible solution that will hold up within the least amount of time and still be able to showcase your skills to prove your worth;
9. We only accept solutions that implement ALL THE FEATURES described above. Incomplete tests or tests that error out won't be considered;
10. If you use JavaScript/TypeScript, you don't need to include the `node_modules` folder. Make sure `npm install` or `yarn` just works. That makes the source code zip files much smaller and easier to attach in an email;
11. We must be able to run your solution with minimal setup (have it documented in the README).

This test must be done in one week or less.

# Sharing your solution
After finishing your implementation, **DO NOT** push your code to GitHub, GitLab, or any other **publicly** available repository. Put the solution in a **PRIVATE** repository and give access to the person interviewing you. You can also zip the project folder (including the .git directory) and send the zip file to the person interviewing you.
