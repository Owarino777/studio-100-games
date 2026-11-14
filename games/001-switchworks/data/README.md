# Experimental Archipel Postal level

`archipel_double_flux.json` is a new representative **District 02** level for the native vertical slice. It uses the connectivity of `docs/art/switchworks/EXEMPLE_PLATEAU_6X6.json`, with six independently misoriented elbows. It does not restore any of the 18 historical HTML levels and does not add a third flow, branching tile, free placement, shared crossing or departure delay.

## Coordinates and ports

The grid has exactly six rows and six columns. JSON station coordinates are **zero-based `[row, column]`**; native cell indices are `row * 6 + column`. Nonempty rail strings contain exactly two different letters from N/E/S/W. Native masks are N=1, E=2, S=4 and W=8. Source and destination cells remain fixed. Sources expose an east-facing departure port; stations may be placed within the board for validated test fixtures.

The known solution consists of one clockwise quarter turn at each index **8, 16, 19, 21, 25, 27**, then dispatch. This is a witness with a reference cost of six rotations, **not an optimal PAR claim**. Both routes contain eight cells and are disjoint in that solution. Generic level loading validates structure, stations, tile families and command bounds; it does not silently certify the semantic correctness or optimality of a supplied witness. The shipped witness is checked through `PostalBoard` in the gameplay test runner.

## State contract

- `PostalLevel.load_default()` reads and validates the JSON. `validate_data()` returns errors without logging expected invalid-input scenarios; `from_dictionary()` returns null on invalid data.
- `PostalBoard` owns the current ports. Reading `ports`, level grids/stations or `snapshot()` returns detached copies so a renderer cannot mutate the puzzle accidentally.
- `rotate(index)` rejects stations, empty cells and indices outside the grid. A successful action rotates exactly 90 degrees and increments the rotation counter.
- `undo()` restores the previous edit's ports, rotations and hints. **Attempts remain the number of actual dispatches**; undo cannot erase an observed attempt. `reset()` explicitly starts a new session: initial ports and all three counters at zero, empty undo history.
- `hint()` returns the first mismatched rotatable cell of the known reference, increments the hint counter and records an undoable edit. It does not rotate, dispatch, or expose an optimal solver. It returns -1 when the board is already connected correctly.
- `evaluate()` is pure: it returns deterministic paths/events without changing any counters. `simulate()` increments attempts once and records that evaluation. The screen/controller locks input and animates the event stream; animation is not an authority for success.
- `restore_snapshot()` validates schema version, level identity, all 36 ports, unchanged fixed cells and tile families, and nonnegative integral counters. Invalid input leaves the board untouched. A valid restoration clears undo history and the previous transient result; this initial native schema does **not** claim compatibility with historical browser storage.

Results contain `success`, `reason`, `failing_cell`, `paths`, `deliveries`, `events`, `ticks` and per-cargo `traces`. Paths use zero-based cell indices and include the source. A connected destination is appended; a missing neighbor connection is not entered. Events are `spawn`, `move`, `delivered` or `failure`, with cargo A/B and an integer simulation tick. Stable failure reasons are `invalid_board`, `outside_board`, `missing_connection`, `wrong_destination`, `loop`, and `unexpected_source`. Expected gameplay failures are data, not script exceptions.

No score, account, advertisement, payment, remote telemetry or authoritative economic value is implemented by this data/model layer. The experiment remains TEST / HOLD for commercial validation.
