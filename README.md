# RadarDetect

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