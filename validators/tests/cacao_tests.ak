use aiken/collection/list
use cacao_traceability.{validate_status_update}
use cacao_traceability/types.{
  Growing, Location, LotInfo, Planted, Processed, TraceabilityDatum,
}
use cacao_traceability/utils.{is_harvest_date_valid, validate_location}

// Función auxiliar para crear una ubicación de prueba
fn create_test_location() -> Location {
  Location {
    latitude: 6252000,
    // 6.252 grados (Medellín)
    longitude: -75581000,
    // -75.581 grados (Medellín)
    region: #"416e74696f71756961",
    // "Antioquia" en hex
    farm_name: #"46696e636120456c204361636175",
  }
  // "Finca El Cacao" en hex
}

// Función auxiliar para crear un lote de prueba
fn create_test_lot() -> LotInfo {
  let location = create_test_location()
  LotInfo {
    lot_id: #"746573745f6c6f745f30303100000000000000000000000000",
    status: Planted,
    plantation_date: 1703980800,
    // 2024-01-01 (timestamp en segundos)
    location,
    certifications: [],
    harvest_records: [],
  }
}

// Función auxiliar para crear un datum de prueba
fn create_test_datum() -> TraceabilityDatum {
  let lot = create_test_lot()
  TraceabilityDatum {
    lot,
    current_owner: #"6f776e65723132333031323334353637383930616263646566",
    creation_date: 1703980800,
  }
}

// Test: Verificar transición de estado válida
test test_valid_status_transition() {
  let datum = create_test_datum()
  validate_status_update(datum, Growing) == True
}

// Test: Verificar transición de estado inválida
test test_invalid_status_transition() {
  let datum = create_test_datum()
  // No se puede saltar de Planted directamente a Processed
  validate_status_update(datum, Processed) == False
}

// Test: Validar coordenadas de ubicación correctas
test test_validate_location_valid() {
  let valid_location =
    Location {
      latitude: 6252000,
      // Latitud válida
      longitude: -75581000,
      // Longitud válida
      region: #"416e74696f71756961",
      // "Antioquia"
      farm_name: #"46696e636120546573742c",
    }
  // "Finca Test"
  validate_location(valid_location) == True
}

// Test: Validar coordenadas de ubicación inválidas
test test_validate_location_invalid() {
  let invalid_location =
    Location {
      latitude: 91000000,
      // Latitud inválida (>90 grados)
      longitude: -75581000,
      region: #"416e74696f71756961",
      farm_name: #"46696e636120546573742c",
    }
  validate_location(invalid_location) == False
}

// Test: Verificar fechas de cosecha válidas
test test_harvest_date_valid() {
  let plantation_date = 1703980800
  // 2024-01-01
  let valid_harvest = 1735603200
  // 2024-12-31 (más de 1 año después)
  is_harvest_date_valid(plantation_date, valid_harvest) == True
}

// Test: Verificar fechas de cosecha inválidas
test test_harvest_date_invalid() {
  let plantation_date = 1703980800
  // 2024-01-01
  let invalid_harvest = 1706659200
  // 2024-01-31 (solo 1 mes después)
  is_harvest_date_valid(plantation_date, invalid_harvest) == False
}

// Test: Verificar creación correcta de lote
test test_lot_creation() {
  let lot = create_test_lot()
  // Verificar que el lote se crea con estado inicial correcto
  lot.status == Planted && list.is_empty(lot.certifications) && list.is_empty(
    lot.harvest_records,
  )
}

// Test: Verificar creación correcta de datum
test test_datum_creation() {
  let datum = create_test_datum()
  // Verificar que el datum tiene los campos correctos
  datum.lot.status == Planted && datum.creation_date > 0
}

// Test: Verificar ubicación no vacía
test test_location_not_empty() {
  let location = create_test_location()
  // Verificar que los campos de ubicación no están vacíos
  location.farm_name != #"" && location.region != #""
}
