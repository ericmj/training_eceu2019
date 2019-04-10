defmodule ChatClient do
  def start() do
    address = String.trim(IO.gets("Server address: "))
    IO.inspect(address)
  end
end
