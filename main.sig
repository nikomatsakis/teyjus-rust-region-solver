sig main.

kind region type.
type reg string -> region.
type free region -> o.
type outlives region -> region -> o.
type outlives_base region -> region -> o.
type outlives_known region -> region -> o.
type record region -> region -> o.
type test string -> o.
