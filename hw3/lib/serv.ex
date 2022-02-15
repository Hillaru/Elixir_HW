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
    serve(socket)
    cycle(listen_socket)
  end

  defp serve(socket) do
    {:ok, msg} = :gen_tcp.recv(socket, 0)
    IO.puts(msg)

    [_, action, id | _] = split_string(msg)
    IO.puts("action = #{action}, id = #{id}")

    html = generate_html(action, id)
    response = if (html == :error || html == :ok) do
      File.read!("resources/MainMenu.html")
    else
      "HTTP/1.1 200 OK\nContent-Type: text/html; charset=utf-8\n\n\n<html>\n<body\n<p>" <> html
    end

    :gen_tcp.send(socket, response)
    :gen_tcp.close(socket)
  end

  defp split_string(string) do
    [_, action, id | _] = String.split(string, [" ", "/", " /"])
  end

  defp generate_html("favicon.ico", _) do
    :ok
  end
  defp generate_html("getallstaff", _) do
    {:ok, data} = MyXQL.query(db, "SELECT * FROM staff")
    "<h1>All Staff data</h1><br><table>" <> output([data.columns, data.rows]) <> "</table>"
  end
  defp generate_html("getstaff", id) do
    {:ok, data} = MyXQL.query(db, "SELECT * FROM staff WHERE Staff_id = ?", [id])
    "<h1>Staffs with #{id} id data</h1><br><table>" <> output([data.columns, data.rows]) <> "</table>"
  end
  defp generate_html(_, _) do
    :error
  end

  defp output([[id, fName, lName, patr, pass, phone] | data]) do
    string = "<tr><td><h4>#{id}</h4></td><td><h4>#{fName}</h4></td><td><h4>#{lName}</h4></td><td><h4>#{patr}</h4></td><td><h4>#{pass}</h4></td><td><h4>#{phone}</h4></td></tr>"
    output(string, data)
  end
  defp output(string, [[id, fName, lName, patr, pass, phone] | data]) do
    string = string <> "<tr><td>#{id}</td><td>#{fName}</td><td>#{lName}</td><td>#{patr}</td><td>#{pass}</td><td>#{phone}</td></tr>"
  end
  defp output(string, []) do
    string
  end
end