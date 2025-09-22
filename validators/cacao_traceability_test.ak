use cacao_traceability.{validate_status_update}
use cacao_traceability/types.{
  Growing, Location, LotInfo, Planted, Processed, TraceabilityDatum,
}

// Test para validación de transición de estado válida
test test_status_update_planted_to_growing() {
  let location =
    Location {
      latitude: 6240000,
      longitude: -75590000,
      region: #"416e74696f71756961",
      farm_name: #"4661726d61204361636175",
    }
  let lot_info =
    LotInfo {
      lot_id: #"746573745f6c6f745f303031",
      status: Planted,
      plantation_date: 1000000,
      location,
      certifications: [],
      harvest_records: [],
    }
  let datum =
    TraceabilityDatum {
      lot: lot_info,
      current_owner: #"6f776e65723132333031323334353637383930616263646566",
      creation_date: 1000000,
    }
  validate_status_update(datum, Growing) == True
}

// Test para transición inválida de estado
test test_status_update_invalid_transition() {
  let location =
    Location {
      latitude: 6240000,
      longitude: -75590000,
      region: #"416e74696f71756961",
      farm_name: #"4661726d61204361636175",
    }
  let lot_info =
    LotInfo {
      lot_id: #"746573745f6c6f745f303032",
      status: Planted,
      plantation_date: 1000000,
      location,
      certifications: [],
      harvest_records: [],
    }
  let datum =
    TraceabilityDatum {
      lot: lot_info,
      current_owner: #"6f776e65723132333031323334353637383930616263646566",
      creation_date: 1000000,
    }
  validate_status_update(datum, Processed) == False
}
