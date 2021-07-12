defmodule RadarDetect.Repo.Migrations.CreateQuadrants do
  use Ecto.Migration

  def change do
    create table(:quadrants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :x_axis, :integer
      add :y_axis, :integer
      add :value, :integer
      add :matrix_id, references(:matrices, on_delete: :delete_all, type: :binary_id)
    end
  end
end
