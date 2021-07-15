defmodule RadarDetectWeb.QuadrantController do
  use RadarDetectWeb, :controller

  alias RadarDetect.Radar
  alias RadarDetect.Radar.Quadrant

  action_fallback RadarDetectWeb.FallbackController

  def fetch_fighters(conn, %{"x" => x_axis, "y" => y_axis} = params) do
    x = String.to_integer(x_axis)
    y = String.to_integer(y_axis)

    with {:ok, _quadrant} <- Radar.quadrant_exists(x,y) do
      fighters = Radar.tie_fighters_around(x,y)
      conn
      |> put_status(:ok)
      |> render("quadrant.json", fighters: fighters)
    else
      {:error, _any} -> conn
      |> put_status(:unprocessable_entity)
      |> render("422.json")
    end
  end

  def sort_quadrants(conn, limit) do

    quadrants = 
      if limit == %{} do
          Radar.sort_by_fighters()
      else
        %{"limit" => sort_limit} = limit 
        sort_limit |> String.to_integer() |> Radar.sort_by_fighters()
      end

    conn
    |> put_status(:ok)
    |> render("sorted_quadrants.json", quadrants: quadrants)
  end
end
