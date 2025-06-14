defmodule PhoenixDemoChatWeb.Token do
  @salt "phoenix token"
  @max_age 86400

  def sign(context, data) do
    Phoenix.Token.sign(context, @salt, data)
  end

  def verify(context, token) do
    verify(context, token, @max_age)
  end

  def verify(context, token, max_age) do
    Phoenix.Token.verify(context, @salt, token, max_age: max_age)
  end
end
