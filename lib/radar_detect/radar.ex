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

  def create_matrix(_attrs) do
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
  Insert's a new quadrant to the database

  ## Examples

      iex> new_quadrant(%{field: value})
      {:ok, %Quadrant{}}

      iex> new_quadrant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def new_quadrant(attrs) do
    %Quadrant{}
      |> Quadrant.changeset(attrs)
      |> Repo.insert() 
  end

  @doc """
  creates all quadrants with their specified locations on the given matrix
  """

  def load_quadrants(input, matrix) do
    input 
    |> traverse({0,0}, matrix, [])
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.map(fn q -> 
      new_quadrant(q)
    end)
    |> Flow.run()
  end

  @doc """
  Builds a list of valid quadrants from the given input and attaches the quadrants to the relevant matrix
  """

  def traverse([], _point, _matrix, acc) do
    acc
  end  

  def traverse([h|t], {x,y}, %{width: width, id: id} = matrix, acc) when x < width do
    new_acc = List.insert_at(acc, 0, %{location: %{x_axis: x, y_axis: y}, value: h, matrix_id: id})
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

  defp left({x,y}) do
    {x-1, y}
  end

  defp down({x,y}) do
    {x, y+1}
  end

  defp up({x,y}) do
    {x, y-1}
  end

  defp string_to_list_of_ints(str) do
    str
    |> String.split(",") 
    |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end)
  end

  @doc """
  given the location of one quadrant, finds the location of all its sorrounding quadrants
  """

  def sorrounding_quadrants_location(x,y) do
    new_acc = [%{x_axis: x-1, y_axis: y-1}, %{x_axis: x, y_axis: y}]
    radar_around(new_acc, {x-1, y-1})
  end

  @doc """
  goes round the quadrant fetching sorounding quadrant location coordinates
  """

  def radar_around(acc, point) when length(acc) < 4 do
    {x,y} = right(point)
    acc
    |> List.insert_at(0, %{x_axis: x, y_axis: y})
    |> radar_around({x,y})
  end

  def radar_around(acc, point) when length(acc) < 6 do
    {x,y} = down(point)
    acc
    |> List.insert_at(0, %{x_axis: x, y_axis: y})
    |> radar_around({x,y})
  end

  def radar_around(acc, point) when length(acc) < 8 do
    {x,y} = left(point)
    acc
    |> List.insert_at(0, %{x_axis: x, y_axis: y})
    |> radar_around({x,y})
  end

  def radar_around(acc, point) when length(acc) >= 8 do
    {x,y} = up(point)
    acc |> List.insert_at(0, %{x_axis: x, y_axis: y})
  end

  @doc """
  query for only the existing and valid quadrants with the given sorrounding quadrant locations returns the total number of fightes and coordinates on=f the quadrant
  """

  def tie_fighters_around(x,y) do
    tie_fighters = sorrounding_quadrants_location(x,y)
    recording_query =
      from(
        q in Quadrant,
        where: q.location in ^tie_fighters,
        select: sum(q.value)
      )
    no_of_fighters = recording_query |> Repo.all() |> List.first()

    %{total: no_of_fighters, x: x, y: y}
  end

  @doc """
  Sorts all the available quadrants by the number of tie fighters and limits the output to the given limit(if any)
  """

  def sort_by_fighters(limit \\ false) do
    all_quadrants = Repo.all(Quadrant)

    limit = if limit, do: limit, else: length(all_quadrants)

    all_quadrants
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.map(fn q -> 
        %{"x_axis" => x, "y_axis" => y} = q.location
        tie_fighters_around(x,y)
      end)
    |> Enum.sort_by(& {&1[:total], &1[:x], &1[:y]}, :desc)
    |> Enum.take(limit)
  end

  @doc """
  checks if a quadrant exists based on its coordinates
  """
  def quadrant_exists(x,y) do
    case Repo.get_by(Quadrant, location: %{x_axis: x, y_axis: y}) do
      nil -> {:error, :unprocessable_entity}
      quadrant -> {:ok, quadrant}
    end
  end
end
