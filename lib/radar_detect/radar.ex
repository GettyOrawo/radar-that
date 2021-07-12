defmodule RadarDetect.Radar do
  @moduledoc """
  The Radar context.
  """

  import Ecto.Query, warn: false
  alias RadarDetect.Repo

  alias RadarDetect.Radar.Matrix
   alias RadarDetect.Radar.Quadrant

  @doc """
  Creates a matrix.

  ## Examples

      iex> create_matrix(%{field: value})
      {:ok, %Matrix{}}

      iex> create_matrix(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_matrix(attrs \\ %{}) do
    %Matrix{}
    |> Matrix.changeset(attrs)
    |> Repo.insert()
  end

  def load_matrix(%{x_axis_size: x_axis_size, input: input}) do
    # {"x_axis_size": 6, "input": "5,5,6,7,8,9,3,3,4,5,6,0"}
    height = string_to_list_of_ints(input) |> length() |> div(x_axis_size)

    {:ok, matrix} = create_matrix(%{height: height, width: x_axis_size})
    hii = load_quadrants(matrix, string_to_list_of_ints(input))
    Quadrant
    |> Repo.insert_all(hii)
    
  end

  def load_quadrants(matrix, input) do
    traverse(input, {0,0}, matrix, [])
  end

  def traverse([], {_x,y}, %{height: height}, acc) do
    acc
  end  

  def traverse([h|t], {x,y}, %{width: width, id: id} = matrix, acc) when x < width do
    new_acc = List.insert_at(acc, 0, %{x_axis: x, y_axis: y, value: h, matrix_id: id})
    new_point = right({x,y})
    traverse(t, new_point, matrix, new_acc)
  end


  def traverse(input, {x,y}, %{height: height, width: width} = matrix, acc) when x >= width do
    new_point = down({0,y})
    if y+1 <= height do
      traverse(input, new_point, matrix, acc)
    else
      acc
    end
  end

  defp right({x,y}) do
    {x+1, y}
  end

  defp down({x,y}) do
    {x, y+1}
  end

  defp string_to_list_of_ints(str) do
    str
    |> String.split(",") 
    |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end)
  end
end
