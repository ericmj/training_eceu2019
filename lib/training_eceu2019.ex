defmodule ChatClient do
  def start() do
    {hostname, port} = get_address()
    {:ok, socket} = :gen_tcp.connect(hostname, port, mode: :binary, active: true)

    loop(socket)
  end

  defp loop(socket) do
    receive do
      {:tcp, ^socket, data} ->
        data
        |> decode_packet()
        |> handle_message()

        loop(socket)

      {:tcp_closed, ^socket} ->
        raise "TCP connection was closed"

      {:tcp_error, ^socket, reason} ->
        raise "TCP connection error: #{:inet.format_error(reason)}"
    end
  end

  defp handle_message(%{kind: :welcome, users_online: num_users}) do
    IO.puts("Welcome! There are #{num_users} users online.")
  end

  defp handle_message(%{kind: :broadcast, nickname: nickname, message: message}) do
    IO.puts("#{nickname}: #{message}")
  end

  defp handle_message(unknown_message) do
    IO.puts("Unknown message #{inspect(unknown_message)}")
  end

  defp decode_packet(<<packet_size::size(16), packet::binary-size(packet_size)>>) do
    :erlang.binary_to_term(packet)
  end

  defp get_address() do
    address = String.trim(IO.gets("Server address (localhost:4000): "))

    if address == "" do
      {'localhost', 4000}
    else
      [hostname, port] = String.split(address, ":")
      {String.to_charlist(hostname), String.to_integer(port)}
    end
  end
end
