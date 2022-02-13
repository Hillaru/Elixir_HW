defmodule Serv do
  @moduledoc """
  Nothing.
  """

  @doc """
  Nothing.
  """

  def main() do
    {:ok, db} = MyXQL.start_link(username: "hillaru", database: "test_db", protocol: :tcp)
    cycle(db)
  end

  defp cycle(db) do
    id = IO.gets("Enter staff id: ") |> String.trim
    one_staff(db, id) |> output()
    cycle(db)
  end

  def all_staff(db) do
    {ok, data} = MyXQL.query(db, "SELECT * FROM staff")
    [data.columns, data.rows]
  end

  def one_staff(db, id) do
    {ok, data} = MyXQL.query(db, "SELECT * FROM staff WHERE Staff_id = ?", [id])
    [data.columns, data.rows]
  end

  def output([[id, fName, lName, patr, pass, phone], data]) do
    IO.puts("#{id}, #{fName}, #{lName}, #{patr}, #{pass}, #{phone}")
    output_data(data)
  end

  defp output_data([]) do
    :ok
  end
  defp output_data([[id, fName, lName, patr, pass, phone] | tail]) do
    IO.puts("#{id}, #{fName}, #{lName}, #{patr}, #{pass}, #{phone}")
    output_data(tail)
  end
end
