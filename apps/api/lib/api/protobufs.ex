defmodule ApiWeb.Protobufs do
  use Protobuf, from: Path.wildcard(Path.expand("../proto_definitions/*.proto", __DIR__))
end

