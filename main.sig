sig main.

kind region type.
kind constraint type.
type reg string -> region.
type free region -> o.
type outlives region -> region -> (list constraint) -> (list constraint) -> o.
type outlives_base region -> region -> o.
type outlives_known region -> region -> o.
type record region -> region -> (list constraint) -> (list constraint) -> o.
type test string -> o.
type test2 string -> (list constraint) -> o.
type subset region -> region -> constraint.
