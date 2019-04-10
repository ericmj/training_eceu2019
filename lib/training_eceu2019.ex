defmodule ChatClient do
  def start() do
    {hostname, port} = get_address()
    {:ok, socket} = :gen_tcp.connect(hostname, port, mode: :binary, active: true)

    loop(socket)
  end

  defp loop(socket) do
    receive do
      {:tcp, ^socket, data} ->
        IO.inspect(data)
        loop(socket)

      {:tcp_closed, ^socket} ->
        raise "TCP connection was closed"

      {:tcp_error, ^socket, reason} ->
        raise "TCP connection error: #{:inet.format_error(reason)}"
    end
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
