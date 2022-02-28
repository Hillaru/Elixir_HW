defmodule MongoElixir do
  @moduledoc """
  """
  @doc """
  """
  def main(args) do
    {:ok, conn} = Mongo.start_link(url: "mongodb://localhost:27017/tets_db")
    cursor = Mongo.find(conn, "people", %{})
    cursor |> Enum.to_list()
  end
end
