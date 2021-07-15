defmodule RadarDetectWeb.QuadrantView do
  use RadarDetectWeb, :view
  alias RadarDetectWeb.QuadrantView

  def render("quadrant.json", %{fighters: fighters, location: %{"x_axis" => x, "y_axis" => y}}) do
    %{total: fighters, x: x, y: y}
  end

  def render("422.json", _assigns) do
    %{errors: %{detail: "Invalid input"}}
  end
end
