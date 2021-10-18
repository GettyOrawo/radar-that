defmodule RadarDetectWeb.QuadrantView do
  use RadarDetectWeb, :view
  alias RadarDetectWeb.QuadrantView

  def render("quadrant.json", %{fighters: fighters}) do
    fighters
  end

  def render("sorted_quadrants.json", %{quadrants: quadrants}) do
    quadrants
  end

  def render("422.json", _assigns) do
    %{errors: %{detail: "Invalid input"}}
  end
end
