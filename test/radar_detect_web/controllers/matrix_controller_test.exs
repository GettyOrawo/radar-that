defmodule RadarDetectWeb.MatrixControllerTest do
  use RadarDetectWeb.ConnCase

  alias RadarDetect.Radar

  @create_attrs %{
    x_axis_size: 6,
    input: "5,5,6,7,8,9,3,3,4,5,6,0"
  }

  @invalid_attrs %{x_axis_size: 0, input: nil}

  def fixture(:matrix) do
    {:ok, matrix} = Radar.create_matrix(@create_attrs)
    matrix
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create matrix" do
    test "renders matrix when data is valid", %{conn: conn} do
      conn = post(conn, Routes.matrix_path(conn, :create), @create_attrs)

      _matrix = fixture(:matrix)
      assert _matrix = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.matrix_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{ errors: %{ detail: "Invalid input"}}
    end
  end

  describe "get tie fighters sorrounding a quadrant" do
    test "renders number of fighters", %{conn: conn} do
      fixture(:matrix)
      conn = get(conn, Routes.quadrant_path(conn, :fetch_fighters, 0, 0))
      assert %{"total" => 16, "x" => 0, "y" => 0} = json_response(conn, 200)
    end
  end

  # defp create_matrix(_) do
  #   matrix = fixture(:matrix)
  #   %{matrix: matrix}
  # end
end
