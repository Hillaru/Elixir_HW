defmodule Serv do
  @moduledoc """
  Nothing.
  """

  @doc """
  Nothing.
  """
  
  def main() do
      {:ok, db} = MyXQL.start_link(username: "hillaru", database: "test_db")
      cycle(db)
  end

  defp cycle(db) do
      id = IO.gets("Enter staff id: ") |> String.trim
      try do
        one_staff(db, id) |> output()
      rescue
        e -> IO.puts("Error")
      end
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

  def output([[Id, FName, LName, Patr, Pass, Phone], data]) do
      IO.puts("#{Id}, #{FName}, #{LName}, #{Patr}, #{Pass}, #{Phone}")
      output_data(data)
  end
  
  defp output_data([]) do
      :ok
  end
  defp output_data([[Id, FName, LName, Patr, Pass, Phone] | tail]) do
      IO.puts("#{Id}, #{FName}, #{LName}, #{Patr}, #{Pass}, #{Phone}")
      output_data(tail)
  end
end
