defmodule RadarDetect.Radar.Quadrant do
  use Ecto.Schema
  import Ecto.Changeset
  alias RadarDetect.Repo

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
    |> cast(attrs, [:location, :value, :matrix_id])
    |> validate_required([:location, :value, :matrix_id])
    |> unsafe_validate_unique(:location, Repo)
  end
end