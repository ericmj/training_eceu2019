defmodule ChatClient do
  def start() do
    {hostname, port} = get_address()
    IO.inspect({hostname, port})
  end

  defp get_address() do
    address = String.trim(IO.gets("Server address (localhost:4000): "))

    if address == "" do
      {"localhost", 4000}
    else
      [hostname, port] = String.split(address, ":")
      port = String.to_integer(port)
      {hostname, port}
    end
  end
end
