defmodule Serv_json do
  @moduledoc """
  Nothing.
  """

  @doc """
  Nothing.
  """

  def main(args \\ []) do
    port = 1480
    {:ok, pid} = MyXQL.start_link(username: "hillaru", database: "test_db", protocol: :tcp)
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
    :erlang.register(:db, pid)
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

    response = generate_response(action, id)
    result = if (response == :error || response == :ok) do
      %{:commands => ["/getallstaff", "/getstaff/id"]}
    else
      response
    end

    {status, json} = JSON.encode(result)
    :gen_tcp.send(socket, json)
    :gen_tcp.close(socket)
  end

  defp split_string(string) do
    [_, action, id | _] = String.split(string, [" ", "/", " /"])
  end

  defp generate_response("favicon.ico", _) do
    :ok
  end
  defp generate_response("getallstaff", _) do
    {:ok, data} = MyXQL.query(:db, "SELECT * FROM staff")
    %{:all_staff => output([data.columns, data.rows])}

  end
  defp generate_response("getstaff", id) do
    {:ok, data} = MyXQL.query(:db, "SELECT * FROM staff WHERE Staff_id = ?", [id])
    output([data.columns, data.rows])
  end
  defp generate_response(_, _) do
    :error
  end

  defp output([[id, fName, lName, patr, pass, phone] | [data]]) do
    json = %{:columns => [id, fName, lName, patr, pass, phone]}
    result_json = [json]
    output(result_json, data)
  end
  defp output(result_json, [[id, fName, lName, patr, pass, phone] | data]) do
    new_result_json = result_json ++ [%{:id => id, :fName => fName, :lName => lName, :patr => patr, :pass => pass, :phone => phone}]
    output(new_result_json, data)
  end
  defp output(result_json, []) do
    result_json
  end
end
