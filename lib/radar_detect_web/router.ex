defmodule RadarDetectWeb.Router do
  use RadarDetectWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RadarDetectWeb do
    pipe_through :api
  end

  post "/api/radar", RadarDetectWeb.MatrixController, :create

  get "/api/radar/:x/:y", RadarDetectWeb.QuadrantController, :fetch_fighters

  get "/api/radar", RadarDetectWeb.QuadrantController, :sort_quadrants

  get "/api/radar/:limit", RadarDetectWeb.QuadrantController, :sort_quadrants
end
