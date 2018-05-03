defmodule Salsa20 do
  @on_load :load_nifs

  app = Mix.Project.config[:app]

  def load_nifs do
    path = :filename.join(:code.priv_dir(unquote(app)), 'salsa20_nif')
    :ok = :erlang.load_nif(path, 0)
  end

  def encrypt(_plain_text, _key, _iv) do
    raise "NIF encrypt/3 not implemented"
  end
end
