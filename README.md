# Space Code Platform

## Running the project
### Install dependencies
* Docker
* Docker compose

You can follow the official guides for these technologies to be able to install them if you don't have them.\
[Tutorial Docker](https://docs.docker.com/engine/install/ubuntu/)\
[Tutorial Docker Compose](https://docs.docker.com/compose/install/)

### Steps
#### 1 - Clone the repository
`git clone https://github.com/tarv7/space-code-platform`
#### 2 - Access folder of the repository
`cd space-code-platform`
#### 3 - build the services
`docker-compose up --build -d`
#### 4 - Prepare the database
`docker exec -it space-code-platform_web_1 rails db:create db:migrate db:seed`
#### 5 - Active the cache for development
`docker exec -it space-code-platform_web_1 rails dev:cache`

#### Some useful commands
* `docker attach space-code-platform_web_1` for attach the rails server
* `docker exec -it space-code-platform_web_1 rails c` for access rails console
* `docker exec -it -e "RAILS_ENV=test" space-code-platform_web_1 rspec` to run all automated tests
* `docker exec -it space-code-platform_web_1 rubocop` to see all warning cops
* `docker exec -it space-code-platform_web_1 bundle-audit` to see all vulnerabilities in gems
* `docker exec -it space-code-platform_web_1 rails rswag:specs:swaggerize` to update documentation

## Using the API
when serving the application, by default it is available at the address: http://localhost:3000/
### List enpoints availables
* GET /api/v1/planets
* GET /api/v1/travel_routes
* POST /api/v1/pilots
* POST /api/v1/contracts
* GET /api/v1/contracts/opened
* PATCH /api/v1/contracts/{id}/accept
* POST /api/v1/travels
* PATCH /api/v1/ships/{id}/fuel
* GET /api/v1/reports

The project is using Swagger to document its API. This way you will be able to access all the details of each endpoint, as well as interact with it. Follow the link to access:\
[Documentation API](http://localhost:3000/api-docs/index.html)

