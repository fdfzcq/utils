defmodule ProcessesUtils do
  def pid_with_largest_heap() do
    pid =
      Process.list()
      |> Enum.max_by(fn pid ->
        pid
        |> Process.info()
        |> Keyword.get(:heap_size)
      end)

    Process.info(pid)
  end

  def count_processes(),
    do:
      Process.list()
      |> Enum.reduce(%{}, &count_process/2)

  defp count_process(pid, acc) when is_pid(pid),
    do:
      pid
      |> Process.info()
      |> count_process(acc)
      |> Enum.reject(fn({_pid, n}) -> n < 50 end)
      |> Enum.into(%{})

  defp count_process(nil, acc), do: acc

  defp count_process(info, acc) do
    registered_name = Keyword.get(info, :registered_name)
    count = acc[registered_name] || 0
    Map.put(acc, registered_name, count + 1)
  end
end
