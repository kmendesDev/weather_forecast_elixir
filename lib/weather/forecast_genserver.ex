defmodule Weather.ForecastGenServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def async_get_forecast do
    GenServer.cast(__MODULE__, :get_forecast)
  end

  @impl true
  def init(state) do
    schedule_forecast()
    {:ok, state}
  end

  @impl true
  def handle_cast(:get_forecast, state) do
    Task.start(fn -> Weather.Forecasts.Forecast.get_forecast("Natal", "RN", "Brasil") end)
    {:noreply, state}
  end

  @impl true
  def handle_info(:scheduled_forecast, state) do
    async_get_forecast()
    schedule_forecast()
    {:noreply, state}
  end

  defp schedule_forecast do
    Process.send_after(self(), :scheduled_forecast, 3_000)
  end
end