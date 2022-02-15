defmodule Serv do
  @moduledoc """
  Nothing.
  """

  @doc """
  Nothing.
  """

  def main() do
    port = 1480
    {:ok, pid} = MyXQL.start_link(username: "hillaru", database: "test_db", protocol: :tcp)
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
    :erlang.register(db, pid)
    cycle(socket)
  end

  defp cycle(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)

    cycle(listen_socket)
  end

  defp serve(socket) do
    {:ok, msg} = :gen_tcp.recv(socket, 0)
    IO.puts(msg)

    [_, action, id | _] = split_string(msg)
    IO.puts("action = #{action}, id = #{id}")

    html = generate_html(action, id)
  end

  defp split_string(string) do
    [_, action, id | _] = String.split(string, [" ", "/", " /"])
  end

  defp generate_html("favicon.ico", _) do
    :ok
  end
  defp generate_html("getallstaff", _) do
    {:ok, data} = MyXQL.query(db, "SELECT * FROM staff")
    [data.columns, data.rows]
  end
  defp generate_html("getstaff", id) do
    {:ok, data} = MyXQL.query(db, "SELECT * FROM staff WHERE Staff_id = ?", [id])
    [data.columns, data.rows]
  end
  defp generate_html(_, _) do
    :error
  end
end