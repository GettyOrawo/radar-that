defmodule RadarDetectWeb.QuadrantControllerTest do
  use RadarDetectWeb.ConnCase

  alias RadarDetect.Radar

  @create_attrs %{
    x_axis_size: 6,
    input: "5,5,6,7,8,9,3,3,4,5,6,0"
  }

  @create_attrs2 %{
    x_axis_size: 5,
    input: "6,4,1,2,5,4,1,3,3,2,2,3,5,4,3,3,2,3,3,3,1,2,2,7,3"
  }

  @create_attrs3 %{
    x_axis_size: 4,
    input: "5,4,6,0,3,4,2,0,3,4,1,1,5,3,6,4"
  }

  def fixture(:matrix) do
    {:ok, matrix} = Radar.create_matrix(@create_attrs)
    matrix
  end

  def fixture2(:matrix) do
    {:ok, matrix} = Radar.create_matrix(@create_attrs2)
    matrix
  end

  def fixture3(:matrix) do
    {:ok, matrix} = Radar.create_matrix(@create_attrs3)
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

    test "2: renders number of fighters", %{conn: conn} do
      fixture2(:matrix)
      conn = get(conn, Routes.quadrant_path(conn, :fetch_fighters, 3, 3))
      assert %{"total" => 33, "x" => 3, "y" => 3} = json_response(conn, 200)
    end

    test "3: renders number of fighters", %{conn: conn} do
      fixture3(:matrix)
      conn = get(conn, Routes.quadrant_path(conn, :fetch_fighters, 1, 2))
      assert %{"total" => 31, "x" => 1, "y" => 2} = json_response(conn, 200)
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
      conn = get(conn, Routes.quadrant_path(conn, :sort_quadrants, 4))
      assert [
              %{"total" => 36, "x" => 3, "y" => 1},
              %{"total" => 36, "x" => 3, "y" => 0},
              %{"total" => 35, "x" => 4, "y" => 1},
              %{"total" => 35, "x" => 4, "y" => 0}
            ] = json_response(conn, 200)
    end

    test "2: renders list of some sorted quadrants based on the output limit given", %{conn: conn} do
      fixture3(:matrix)
      conn = get(conn, Routes.quadrant_path(conn, :sort_quadrants, 3))
      assert [%{"total" => 32, "x" => 1, "y" => 1}, %{"total" => 31, "x" => 1, "y" => 2}, %{"total" => 25, "x" => 2, "y" => 2}] = json_response(conn, 200)
    end
  end
end
