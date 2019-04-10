defmodule ChatClient do
  def start() do
    address = String.trim(IO.gets("Server address (localhost:4000): "))

    {hostname, port} =
      if address == "" do
        {"localhost", 4000}
      else
        [hostname, port] = String.split(address, ":")
        port = String.to_integer(port)
        {hostname, port}
      end

    IO.inspect({hostname, port})
  end
end
