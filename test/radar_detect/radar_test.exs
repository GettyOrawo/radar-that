defmodule RadarDetect.RadarTest do
  use RadarDetect.DataCase

  alias RadarDetect.Radar

  describe "matrices" do
    alias RadarDetect.Radar.Matrix

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
  end
end
