## DataTypes

| | UTF-16 Encoding | https://www.fda.gov/food/buy-store-serve-safe-food/what-you-need-know-about-food-allergies |  |  |  |  |  |  |  |  |  | 
| | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | 
| |  | Type  | Length  | Size (bytes) | Total (bytes) | Total (KiB) |  |  |  |  |  | 
| | Meal  |  |  |  | 6200 | 138.439453125 | Order |  |  |  | 139 | 
| | Id | guid  | 1 | 16 | 16 |  | order id  | guid  | 1 | 16 | 16 | 
| | Description | string | 500 | 4 | 2000 |  | user id  | guid  | 1 | 16 | 16 | 
| | KitchenId | guid  | 1 | 16 | 16 |  | meal id  | guid  | 3 | 16 | 48 | 
| | Price | float + currency | 1 | 8 | 8 |  | time  | datetime  | 1 | 8 | 8 | 
| | Nutrition Info |  |  |  | 0 |  | source | byte  | 1 | 1 | 1 | 
| | Energy | float + float | 2 | 4 | 8 |  | promo id  | guid  | 2 | 16 | 32 | 
| | Protein | float + float | 2 | 4 | 8 |  | type  | byte  | 1 | 1 | 1 | 
| | Fat | float + float | 2 | 4 | 8 |  | state | byte  | 1 | 1 | 1 | 
| | Saturated fat | float + float | 2 | 4 | 8 |  | feedbackid | guid  | 1 | 16 | 16 | 
| | Carbohydrate  | float + float | 2 | 4 | 8 |  | Feedback  |  |  |  | 4043 | 
| | Sugar | float + float | 2 | 4 | 8 |  | id  | guid | 1 | 16 | 16 | 
| | Sodium | float + float | 2 | 4 | 8 |  | order id | guid | 1 | 16 | 16 | 
| | Vitamins  | float + float | 20 | 4 | 80 |  | date | datetime | 1 | 8 | 8 | 
| | Ingridients | string | 1000 | 4 | 4000 |  | rate  | byte | 3 | 1 | 3 | 
| | Alergens | List<byte> | 8 | 1 | 8 |  | description | string | 1000 | 4 | 4000 | 
| | Type  | guid  | 1 | 16 | 16 |  | Promo |  |  |  | #VALUE! | 
| | Catalog |  |  |  | 124016 |  | id  | guid  | 1 | 16 | 16 | 
| | KitchenId | guid | 1 | 16 | 16 |  | kitchen  | list of guid  | 1 | 16 | 16 | 
| | Meals  | meal | 20 | 6200 | 124000 |  | meal type  | list of guid  | 1 | 16 | 16 | 
| | User  |  |  |  | 7364 |  | meal list  | list of guid  | 3 | 16 | 48 | 
| | id | guid | 1 | 16 | 16 |  | date range | datetime | 2 | 16 | 32 | 
| | Name  | string | 200 | 4 | 800 |  | description | string  | 1000 | 4 | 4000 | 
| | Login | string | 100 | 4 | 400 |  | discount  | float | 4 | 8 | 32 | 
| | Payment info | Payment info | 1 | 1024 | 1024 |  | rules  | list of rules  | 2 | 16 | 32 | 
| | Type  | int | 1 | 4 | 4 |  |  |  |  |  |  | 
| | Preference  | preference | 5 | 1024 | 5120 |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  | #records per day | #records per month | size | unit |  |  |  | 
| |  |  |  |  | 500 | 15000 | 1.98039226233959 | GiB/Month |  |  |  | 
| |  |  |  |  | 1000 | 30000 | 3.96078452467918 | GiB/Month |  |  |  | 
| |  |  |  |  | 5000 | 150000 | 19.8039226233959 | GiB/Month |  |  |  | 
| |  |  |  |  | 10000 | 300000 | 39.6078452467918 | GiB/Month |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  | #VALUE! |  |  |  |  | 

## Forecasts

| |  |  |  |  |  |  |  | 
| | --- | --- | --- | --- | --- | --- | --- | 
| |  |  | Instance size  | Now  | Size (KiB) |  |  | 
| |  | Meal  | 138.439453125 | 15 | 2076.591796875 |  |  | 
| |  | Catalog  | 0 | 1 | 0 |  |  | 
| |  | User  | 0 | 300 | 0 |  |  | 
| |  | Order  | GiB/Month | 630 | #VALUE! |  |  | 
| |  | Feedback  | 0 | 183 | 0 |  |  | 
| |  | Promo | #VALUE! | 4 | #VALUE! |  |  | 
| |  |  |  |  | #VALUE! |  |  | 
| |  |  |  |  |  |  |  | 
| |  | Meal  | 138.439453125 | 20 | 2768.7890625 |  |  | 
| |  | Catalog  | 0 | 2 | 0 |  |  | 
| |  | User  | 0 | 700 | 0 |  |  | 
| |  | Order  | GiB/Month | 1470 | #VALUE! |  |  | 
| |  | Feedback  | 0 | 427 | 0 |  |  | 
| |  | Promo | #VALUE! | 6 | #VALUE! |  |  | 
| |  |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  | 
| |  | Meal  | 138.439453125 | 20 | 2768.7890625 |  |  | 
| |  | Catalog  | 0 | 2 | 0 |  |  | 
| |  | User  | 0 | 500 | 0 |  |  | 
| |  | Order  | GiB/Month | 1600 | #VALUE! |  |  | 
| |  | Feedback  | 0 | 360 | 0 |  |  | 
| |  | Promo | #VALUE! | 6 | #VALUE! |  |  | 
| |  |  |  |  | #VALUE! |  |  | 
| |  |  |  |  |  |  |  | 
| |  | Meal  | 138.439453125 | 20 | 2768.7890625 |  |  | 
| |  | Catalog  | 0 | 2 | 0 |  |  | 
| |  | User  | 0 | 1500 | 0 |  |  | 
| |  | Order  | GiB/Month | 4800 | #VALUE! |  |  | 
| |  | Feedback  | 0 | 1080 | 0 |  |  | 
| |  | Promo | #VALUE! | 6 | #VALUE! |  |  | 
| |  |  |  |  | #VALUE! |  |  | 

## Payload

| | Make Order Request | Length | Size (bytes) | Total (Bytes) | Total (KiB) |  | #Requests | Day | Week | Month |  |  | 
| | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | 
| | user_guid | 1 | 16 | 2664 | 2.6015625 |  | 500 | 1.27029418945313 | 8.89205932617188 | 35.5682373046875 | MiB |  | 
| | meal_guid | 1 | 16 |  |  |  | 1000 | 2.54058837890625 | 17.7841186523438 | 71.136474609375 | MiB |  | 
| | kitchen_guid | 1 | 16 |  |  |  | 5000 | 12.7029418945313 | 88.9205932617188 | 355.682373046875 | MiB |  | 
| | pos_guid |  | 16 |  |  |  | 10000 | 25.4058837890625 | 177.841186523438 | 711.36474609375 | MiB |  | 
| | notes | 500 | 2000 |  |  |  |  |  |  |  |  |  | 
| | http_header | 300 | 600 |  |  |  |  |  |  |  |  |  | 
| | Review Order Request |  |  |  |  |  | 10% of users writes reviews |  |  |  |  |  | 
| | notes | 500 | 2000 | 4196905 | 4098.5400390625 |  | 50 | 200.124025344849 | 1400.86817741394 | 5603.47270965576 | MiB |  | 
| | image | 1 | 4194304 |  |  |  | 100 | 400.248050689697 | 2801.73635482788 | 11206.9454193115 | MiB |  | 
| | rating | 1 | 1 |  |  |  | 500 | 2001.24025344849 | 14008.6817741394 | 56034.7270965576 | MiB |  | 
| | http_header | 300 | 600 |  |  |  | 1000 | 4002.48050689697 | 28017.3635482788 | 112069.454193115 | MiB |  | 
| | Order Feedback Request |  |  |  |  |  | 5% error rate |  |  |  |  |  | 
| | notes | 500 | 2000 | 4196926 | 4098.560546875 |  | 25 | 100.06251335144 | 700.437593460083 | 2801.75037384033 | MiB |  | 
| | image | 1 | 4194304 |  |  |  | 50 | 200.125026702881 | 1400.87518692017 | 5603.50074768066 | MiB |  | 
| | pos_guid | 1 | 16 |  |  |  | 250 | 1000.6251335144 | 7004.37593460083 | 28017.5037384033 | MiB |  | 
| | fridge_guid | 1 | 6 |  |  |  | 500 | 2001.25026702881 | 14008.7518692017 | 56035.0074768066 | MiB |  | 
| | http_header | 300 | 600 |  |  |  |  |  |  |  |  |  | 
| | Accept Order |  |  |  |  |  |  |  |  |  |  |  | 
| | kitchen_guid | 1 | 16 | 632 | 0.6171875 |  | 500 | 0.301361083984375 | 2.10952758789062 | 8.4381103515625 | MiB |  | 
| | order_guid | 1 | 16 |  |  |  | 1000 | 0.60272216796875 | 4.21905517578125 | 16.876220703125 | MiB |  | 
| | http_header | 300 | 600 |  |  |  | 5000 | 3.01361083984375 | 21.0952758789062 | 84.381103515625 | MiB |  | 
| |  |  |  |  |  |  | 10000 | 6.0272216796875 | 42.1905517578125 | 168.76220703125 | MiB |  | 
| |  |  |  |  |  |  |  |  |  |  |  |  | 
| |  |  |  |  |  | #Requests | Day | Week | Month |  |  |  | 
| |  |  |  |  |  | 500 | 0.294685736298561 | 2.06280015408993 | 8.25120061635971 |  |  |  | 
| |  |  |  |  |  | 1000 | 0.589371472597122 | 4.12560030817986 | 16.5024012327194 |  |  |  | 
| |  |  |  |  |  | 5000 | 2.94685736298561 | 20.6280015408993 | 82.5120061635971 |  |  |  | 
| |  |  |  |  |  | 10000 | 5.89371472597122 | 41.2560030817986 | 165.024012327194 |  |  |  | 
| |  |  |  |  |  | Size | MiB | MiB | GiB |  |  |  | 
