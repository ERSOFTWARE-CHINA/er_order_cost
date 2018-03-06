#/bin/bash

docker run --name er_order_cost \
-e POSTGRES_PASSWORD=postgres \
-e POSTGRES_USER=postgres \
-e POSTGRES_DB=restful_api_dev \
-p 5432:5432 \
-d postgres