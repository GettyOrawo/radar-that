defmodule RadarDetect.Radar.Quadrant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "quadrants" do
    field :location, :map
    field :value, :integer
    field :matrix_id, :binary_id
  end

  @doc false
  def changeset(quadrant, attrs) do
    quadrant
    |> cast(attrs, [:location, :value])
    |> validate_required([:location, :value])
  end
end