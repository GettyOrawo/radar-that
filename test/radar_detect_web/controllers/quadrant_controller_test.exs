defmodule RadarDetectWeb.QuadrantControllerTest do
  use RadarDetectWeb.ConnCase

  alias RadarDetect.Radar

  @create_attrs %{
    x_axis_size: 6,
    input: "5,5,6,7,8,9,3,3,4,5,6,0"
  }

  def fixture(:matrix) do
    {:ok, matrix} = Radar.create_matrix(@create_attrs)
    matrix
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end


  describe "get tie fighters sorrounding a quadrant" do
    test "renders number of fighters", %{conn: conn} do
      fixture(:matrix)
      conn = get(conn, Routes.quadrant_path(conn, :fetch_fighters, 0, 0))
      assert %{"total" => 16, "x" => 0, "y" => 0} = json_response(conn, 200)
    end
  end

  describe "sort quadrants based on fighters sorrounding" do
    test "renders list of all sorted quadrants by fighters with no provided limit", %{conn: conn} do
      fixture(:matrix)
      conn = get(conn, Routes.quadrant_path(conn, :sort_quadrants))
      assert [
              %{"total" => 36, "x" => 3, "y" => 1},
              %{"total" => 36, "x" => 3, "y" => 0},
              %{"total" => 35, "x" => 4, "y" => 1},
              %{"total" => 35, "x" => 4, "y" => 0},
              %{"total" => 30, "x" => 2, "y" => 1},
              %{"total" => 30, "x" => 2, "y" => 0},
              %{"total" => 26, "x" => 1, "y" => 1},
              %{"total" => 26, "x" => 1, "y" => 0},
              %{"total" => 23, "x" => 5, "y" => 1},
              %{"total" => 23, "x" => 5, "y" => 0},
              %{"total" => 16, "x" => 0, "y" => 1},
              %{"total" => 16, "x" => 0, "y" => 0}
            ] = json_response(conn, 200)
    end

    test "renders list of some sorted quadrants based on the output limit given", %{conn: conn} do
      fixture(:matrix)
      conn = get(conn, Routes.quadrant_path(conn, :sort_quadrants, limit: 4))
      assert [
              %{"total" => 36, "x" => 3, "y" => 1},
              %{"total" => 36, "x" => 3, "y" => 0},
              %{"total" => 35, "x" => 4, "y" => 1},
              %{"total" => 35, "x" => 4, "y" => 0}
            ] = json_response(conn, 200)
    end
  end
end
