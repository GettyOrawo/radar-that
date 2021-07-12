defmodule RadarDetect.Radar do
  @moduledoc """
  The Radar context.
  """

  import Ecto.Query, warn: false
  alias RadarDetect.Repo

  alias RadarDetect.Radar.Matrix
   alias RadarDetect.Radar.Quadrant

  @doc """
  receives raw request input and creates a valid matrix with quadrants
  """

  def create_matrix(%{x_axis_size: x_axis_size, input: input}) when x_axis_size > 0 do
    height = string_to_list_of_ints(input) |> length() |> div(x_axis_size)
    {:ok, matrix} = load_matrix(%{height: height, width: x_axis_size})

    input
    |> string_to_list_of_ints()
    |> load_quadrants(matrix)

    {:ok, matrix}
  end

  def create_matrix(%{x_axis_size: x_axis_size}) do
    {:error, "invalid input type"}
  end

  @doc """
  Deletes an existing matrix if already exists and creates a new matrix.
  """

  def load_matrix(attrs \\ %{}) do
    case Repo.one(Matrix) do
      nil -> new_matrix(attrs)
      matrix -> 
        Repo.delete(matrix)
        new_matrix(attrs)
    end      
   end

  @doc """
  Insert's a new matrix to the database

  ## Examples

      iex> new_matrix(%{field: value})
      {:ok, %Matrix{}}

      iex> new_matrix(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def new_matrix(attrs) do

    %Matrix{}
    |> Matrix.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  creates all quadrants with their specified locations on the given matrix
  """

  def load_quadrants(input, matrix) do
    quadrants = input |> traverse({0,0}, matrix, [])
    Quadrant
    |> Repo.insert_all(quadrants)

  end

  @doc """
  Builds a list of valid quadrants from the given input and attaches the quadrants to the relevant matrix
  """

  def traverse([], _point, _matrix, acc) do
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
