defmodule Sequence.Server do
  use GenServer

  # Client API Implementation

  def start_link(stash_pid) do
    GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def next_number do
    GenServer.call(__MODULE__, :next_number)
  end

  def set_number(number) do
    GenServer.call(__MODULE__, {:set_number, number})
  end

  def increment_number(delta) do
    GenServer.cast(__MODULE__, {:increment_number, delta})
  end

  # GenServer Implementation

  def init(stash_pid) do
    current_number = Sequence.Stash.get_value(stash_pid)
    {:ok,  {stash_pid, current_number}}
  end

  def handle_call(:next_number, _from, {stash_pid, current_number}) do
    {:reply, current_number, {stash_pid, current_number + 1}}
  end
  def handle_call({:set_number, new_number}, _from, {stash_pid, _current_number}) do
    {:reply, new_number, {stash_pid, new_number}}
  end

  def handle_cast({:increment_number, delta}, {stash_pid, current_number}) do
    {:noreply, {stash_pid, current_number + delta}}
  end

  def terminate(_reason, {stash_pid, current_number}) do
    Sequence.Stash.save_value(stash_pid, current_number)
    {:noreply, current_number}
  end
end
