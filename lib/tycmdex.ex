defmodule Tycmdex do
  @moduledoc """
  Handles gathering the .
  """
  use GenServer
  require Logger

  defstruct cmd_path: nil

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_args) do
    cmd_path =
    :code.priv_dir(:tycmdex)
    |> to_string()
    |> Path.join("/tycmd")

    state = %__MODULE__{
      cmd_path: cmd_path
    }
    {:ok, state}
  end

  def list(pid), do: GenServer.call(pid, :list, 15000)

  def reset(pid, args) do
    bootloader? = Keyword.get(args, :bootloader, false)
    device = Keyword.fetch!(args, :device)
    GenServer.call(pid, {:reset, bootloader?, device}, 15000)
  end

  def upload(pid, args) do
    file = Keyword.fetch!(args, :file)
    device = Keyword.fetch!(args, :device)
    GenServer.call(pid, {:upload, file, device}, 15000)
  end

  def handle_call({:reset, true, device}, _from, %{cmd_path: cmd_path} = state) do
    response =
      MuonTrap.cmd(cmd_path, ["reset", "--board", device, "--bootloader"], stderr_to_stdout: true)
      |> cmd_response()
    {:reply, response, state}
  end

  def handle_call({:reset, false, device}, _from, %{cmd_path: cmd_path} = state) do
    response =
      MuonTrap.cmd(cmd_path, ["reset", "--board", device], stderr_to_stdout: true)
      |> cmd_response()
    {:reply, response, state}
  end

  def handle_call({:upload, file, device}, _from, %{cmd_path: cmd_path} = state) do
    response =
      MuonTrap.cmd(cmd_path, ["upload", "--board", device, file], stderr_to_stdout: true)
      |> cmd_response()
    {:reply, response, state}
  end

  def handle_call(:list, _from, %{cmd_path: cmd_path} = state) do
    response =
      MuonTrap.cmd(cmd_path, ["list", "--output", "json", "--verbose"])
      |> elem(0)
      |> Jason.decode()
    {:reply, response, state}
  end

  def handle_call(_unkwon_call, _from, state) do
    {:reply, {:error, :einval}, state}
  end

  def terminate(reason, state) do
    Logger.error("(#{__MODULE__}) Error: #{inspect({reason, state})}.")
  end

  defp cmd_response({_response, 0}), do: :ok
  defp cmd_response({response, 1}) do
    cond do
      String.match?(response, ~r/Device or resource busy/) ->
        {:error, :eagain}
      true ->
        {:error, :einval}
    end
  end
end
