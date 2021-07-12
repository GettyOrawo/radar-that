defmodule RadarDetectWeb.Router do
  use RadarDetectWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RadarDetectWeb do
    pipe_through :api
  end

  post "/api/radar", RadarDetectWeb.MatrixController, :create
end
