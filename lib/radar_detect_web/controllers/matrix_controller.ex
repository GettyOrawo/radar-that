defmodule RadarDetectWeb.MatrixController do
  use RadarDetectWeb, :controller

  alias RadarDetect.Radar
  alias RadarDetect.Radar.Matrix

  action_fallback RadarDetectWeb.FallbackController

  def create(conn, matrix_params) do
    params = matrix_params |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    with {:ok, matrix} <- Radar.create_matrix(params) do
      conn
      |> put_status(:ok)
      |> render("matrix.json", matrix: matrix)
    else
      {:error, _any} -> conn
      |> put_status(:unprocessable_entity)
      |> render("422.json")
    end
  end
end
