defmodule Sequence do

  use Application

  def start(_start_type, _start_args) do
    Sequence.Supervisor.start_link(123)
  end
end
