defmodule Pinger do
  def ping(echo, limit) do
    receive do
      {[next|rest], msg, count} when count <= limit ->
        IO.puts "Received: #{inspect msg} count #{count}"
        :timer.sleep(1000)
        send next, {rest ++ [next], echo, count + 1}
        ping(echo, limit)
      {[next|rest], _, _} ->
        send next, {rest, :ok}
      {[next|rest], :ok} ->
        send next, {rest, :ok}
    end
  end
end

defmodule Spawner do
  def start do
    limit = 10
    {p1, _} = spawn_monitor(Pinger, :ping, ["p1", limit])
    {p2, _} = spawn_monitor(Pinger, :ping, ["p2", limit])
    {p3, _} = spawn_monitor(Pinger, :ping, ["p3", limit])
    send p1, {[p2, p3, p1], "start", 0}
    wait [p1, p2, p3]
  end

  def wait(pids) do
    IO.puts "waiting for pids #{inspect pids}"
    receive do
      {:DOWN, _, _, pid, _} ->
        IO.puts "#{inspect pid} quit"
        pids = List.delete(pids, pid)
        unless Enum.empty?(pids) do
          wait(pids)
        end
    end
  end
end

Spawner.start

