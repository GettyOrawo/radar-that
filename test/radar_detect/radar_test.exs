defmodule RadarDetect.RadarTest do
  use RadarDetect.DataCase

  alias RadarDetect.Radar
  alias RadarDetect.Repo

  describe "matrices and quadrants" do
    alias RadarDetect.Radar.Matrix
    alias RadarDetect.Radar.Quadrant

    @valid_attrs %{
                    x_axis_size: 6,
                    input: "5,5,6,7,8,9,3,3,4,5,6,0"
                  }
    @invalid_attrs %{
                     x_axis_size: 0,
                     input: ""
                     }

    def matrix_fixture(attrs \\ %{}) do
      {:ok, matrix} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Radar.create_matrix()

      matrix
    end

    test "create_matrix/1 with valid data creates a matrix" do
      assert {:ok, %Matrix{} = matrix} = Radar.create_matrix(@valid_attrs)
      assert matrix.height == 2
      assert matrix.width == 6
    end

    test "create_matrix/1 with invalid data returns error changeset" do
      assert {:error, _any} = Radar.create_matrix(@invalid_attrs)
    end

    test "create_matrix/1 with valid data creates quadrants for the matrix" do
      assert {:ok, %Matrix{} = matrix} = Radar.create_matrix(@valid_attrs)
      q = Repo.all(Quadrant) |> length()
      assert q == matrix.height * matrix.width
    end   

    test "sorrounding_quadrants_location/2 returns all coordinates of the sorrounding quadrants given a quadrant" do
      assert {:ok, %Matrix{} = _matrix} = Radar.create_matrix(@valid_attrs)
      coordinates = Radar.sorrounding_quadrants_location(1,1)
      assert coordinates == [
                              %{x_axis: 0, y_axis: 1},
                              %{x_axis: 0, y_axis: 2},
                              %{x_axis: 1, y_axis: 2},
                              %{x_axis: 2, y_axis: 2},
                              %{x_axis: 2, y_axis: 1},
                              %{x_axis: 2, y_axis: 0},
                              %{x_axis: 1, y_axis: 0},
                              %{x_axis: 0, y_axis: 0},
                              %{x_axis: 1, y_axis: 1}
                            ]
    end   

    test "tie_fighters_around/2 returns sum of all tie fighters in the sorrounding quadrants given a quadrant coordinates" do
      assert {:ok, %Matrix{} = _matrix} = Radar.create_matrix(@valid_attrs)
      fighters = Radar.tie_fighters_around(1,1)
      assert fighters == %{total: 26, x: 1, y: 1}
    end    

    test "sort_by_fighters/1 sorts all the available quadrants by TIE fighters" do
      assert {:ok, %Matrix{} = _matrix} = Radar.create_matrix(@valid_attrs)
      quadrants = Radar.sort_by_fighters()
      assert quadrants == [
                            %{total: 36, x: 3, y: 1},
                            %{total: 36, x: 3, y: 0},
                            %{total: 35, x: 4, y: 1},
                            %{total: 35, x: 4, y: 0},
                            %{total: 30, x: 2, y: 1},
                            %{total: 30, x: 2, y: 0},
                            %{total: 26, x: 1, y: 1},
                            %{total: 26, x: 1, y: 0},
                            %{total: 23, x: 5, y: 1},
                            %{total: 23, x: 5, y: 0},
                            %{total: 16, x: 0, y: 1},
                            %{total: 16, x: 0, y: 0}
                          ]
    end  

    test "sort_by_fighters/1 sorts all the available quadrants and limits output by the given limit" do
      assert {:ok, %Matrix{} = _matrix} = Radar.create_matrix(@valid_attrs)
      quadrants = Radar.sort_by_fighters(4)
      assert quadrants == [%{total: 36, x: 3, y: 1}, %{total: 36, x: 3, y: 0}, %{total: 35, x: 4, y: 1}, %{total: 35, x: 4, y: 0}]
    end  

  end
end
