use aiken/collection/list
use cacao_traceability/types.{
  AddCertification, AddHarvest, Certification, Certified, Flowering, Growing,
  HarvestRecord, Harvesting, Location, PlantationStatus, Planted, Processed,
  PubKeyHash, TraceabilityDatum, TraceabilityRedeemer, TransferOwnership,
  UpdateLocation, UpdateStatus,
}
use cacao_traceability/utils

// Tipos definidos como públicos
pub type OutputReference =
  ByteArray

pub type ScriptContext =
  ByteArray

pub type Transaction {
  Transaction { extra_signatories: List<PubKeyHash> }
}

// Validador con la función spend específica
validator cacao_traceability {
  spend(
    datum: Option<TraceabilityDatum>,
    redeemer: TraceabilityRedeemer,
    _own_ref: OutputReference,
    self: Transaction,
  ) {
    expect Some(d) = datum
    // Evalúa qué tipo de acción se está realizando
    when redeemer is {
      UpdateStatus { new_status } -> validate_status_update(d, new_status)
      AddHarvest { harvest } -> validate_harvest_addition(d, harvest)
      AddCertification { certification } ->
        validate_certification_addition(d, certification, self)
      TransferOwnership { new_owner } ->
        validate_ownership_transfer(d, new_owner, self)
      UpdateLocation { new_location } ->
        validate_location_update(d, new_location, self)
    }
  }

  else(_ctx: ScriptContext) {
    False
  }
}

// Valida que la transición de estado sea válida
pub fn validate_status_update(
  datum: TraceabilityDatum,
  new_status: PlantationStatus,
) -> Bool {
  when (datum.lot.status, new_status) is {
    (Planted, Growing) -> True
    (Growing, Flowering) -> True
    (Flowering, Harvesting) -> True
    (Harvesting, Certified) -> !list.is_empty(datum.lot.certifications)
    (Certified, Processed) -> True
    _ -> False
  }
}

// Valida la adición de cosecha
pub fn validate_harvest_addition(
  datum: TraceabilityDatum,
  harvest: HarvestRecord,
) -> Bool {
  // El lote debe estar en estado de cosecha
  datum.lot.status == Harvesting && // La cantidad debe ser positiva
  harvest.quantity_kg > 0 && // El grado de calidad entre 1 y 10
  harvest.quality_grade >= 1 && harvest.quality_grade <= 10 && // El nivel de humedad entre 0 y 100
  harvest.moisture_level >= 0 && harvest.moisture_level <= 100 && // La fecha de cosecha debe ser válida
  utils.is_harvest_date_valid(datum.lot.plantation_date, harvest.harvest_date)
}

// Valida la adición de certificación
pub fn validate_certification_addition(
  datum: TraceabilityDatum,
  certification: Certification,
  tx: Transaction,
) -> Bool {
  // El ID del lote debe coincidir
  certification.lot_id == datum.lot.lot_id && // La certificación debe estar verificada
  certification.verified && // El certificador debe haber firmado
  list.has(tx.extra_signatories, certification.issued_by) && // No debe existir certificación duplicada del mismo tipo
  !list.any(
    datum.lot.certifications,
    fn(cert) { cert == certification.cert_type },
  )
}

// Valida la transferencia de propiedad
pub fn validate_ownership_transfer(
  datum: TraceabilityDatum,
  new_owner: PubKeyHash,
  tx: Transaction,
) -> Bool {
  // El nuevo propietario debe ser diferente
  new_owner != datum.current_owner && // Ambas partes deben firmar
  list.has(tx.extra_signatories, datum.current_owner) && list.has(
    tx.extra_signatories,
    new_owner,
  ) && // No puede estar en cosecha activa
  datum.lot.status != Harvesting
}

// Valida la actualización de ubicación
pub fn validate_location_update(
  datum: TraceabilityDatum,
  new_location: Location,
  tx: Transaction,
) -> Bool {
  // Solo el propietario puede actualizar
  list.has(tx.extra_signatories, datum.current_owner) && // La ubicación debe ser válida
  utils.validate_location(new_location) && (
    // Solo en estados tempranos
    datum.lot.status == Planted || datum.lot.status == Growing
  )
}
