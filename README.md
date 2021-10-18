# RadarDetect

We (Han solo's fans :) ) need to be aware of the amount of tie fighters in a specific area in case danger strikes. (inspired by *Star Wars*)

To place a specific geographical area visually, we'll think of an area as a matrix of a certain dimension and split the area into quadrants then output the number of fighters per quadrant or on the radar (all sorrounding quadrants). It can be viewed better with x,y coordinates:

```
     0 1 2 3 4 5
--|-|-|-|-|-|-|-|-> (x axis)
0 |  0 3 6 7 8 9
1 |  3 4 2 5 6 0
2 |  5 5 1 0 2 3
3 |  0 1 3 5 9 4
  v
  (y axis)
```
This is a REST API that takes in a matrix x axis and a comma separated string of tie fighters distributed equally across that matrix

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`
  * Run all tests with `mix test`

Now you we are able to access the api through port [`4000`]

To spawn up a new **matrix**, provide the input in form of a comma separated string and the size of your x axis. You can use the curl command below in your terminal:

`curl -d '{"x_axis_size": 6, "input": "5,5,6,7,8,9,3,3,4,5,6,0"}' -H "Content-Type: application/json" -X POST http://localhost:4000/api/radar`

Creating a matrix automatically creates quadrants linked to the matrix, each with a value in the order of the input value entry.

Every time we create a new matrix, the previous maytrix together with all it's quadrants is discarded. (be careful with this action :) )

To access TIE fighters around a quadrant, specify the quadrant coordinates in the curl command below(x and y respectively)

`curl http://localhost:4000/api/radar/0/0`

To sort quadrants according the number of TIE fighters on its radar, use the command below

`curl http://localhost:4000/api/radar`

You can also limit the number of quadrants on the output by passing a limit patrameter

`curl http://localhost:4000/api/radar/3`

Han solo has to be the happiest anyone has ever been!
