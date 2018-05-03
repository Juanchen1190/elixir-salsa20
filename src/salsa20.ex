defmodule Salsa20 do
  @on_load :load_nifs

  def load_nifs do
    :erlang.load_nif('./salsa20_nif', 0)
  end

  def encrypt(_plain_text, _key, _iv) do
    raise "NIF encrypt/3 not implemented"
  end
end
