defmodule Sequence.Stash do

  use GenServer

  # Client API Implementation

  def start_link(initial_number) do
    GenServer.start_link(__MODULE__, initial_number)
  end

  def get_value(pid) do
    GenServer.call(pid, :get_value)
  end

  def save_value(pid, value) do
    GenServer.cast(pid, {:save_value, value})
  end

  # GenServer Implementation

  def handle_call(:get_value, _from, current_number) do
    {:reply, current_number, current_number}
  end

  def handle_cast({:save_value, value}, _state) do
    {:noreply, value}
  end
end
