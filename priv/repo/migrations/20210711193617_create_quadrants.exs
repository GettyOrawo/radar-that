defmodule RadarDetect.Repo.Migrations.CreateQuadrants do
  use Ecto.Migration

  def change do
    create table(:quadrants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :location, :jsonb
      add :value, :integer
      add :matrix_id, references(:matrices, on_delete: :delete_all, type: :binary_id)
    end
  end
end
