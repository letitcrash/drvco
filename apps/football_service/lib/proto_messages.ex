defmodule FootballService.ProtoMessages do
  use Protobuf, from: Path.wildcard(Path.expand("../priv/proto/*.proto", __DIR__))
end
