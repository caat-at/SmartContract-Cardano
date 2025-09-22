// Tipos básicos
pub type PubKeyHash =
  ByteArray

// Estados de la plantación
pub type PlantationStatus {
  Planted
  Growing
  Flowering
  Harvesting
  Certified
  Processed
}

// Tipos de certificación
pub type CertificationType {
  Organic
  FairTrade
  RainforestAlliance
  UTZ
}

// Ubicación geográfica
pub type Location {
  Location {
    latitude: Int,
    longitude: Int,
    region: ByteArray,
    farm_name: ByteArray,
  }
}

// Registro de cosecha
pub type HarvestRecord {
  HarvestRecord {
    harvest_id: ByteArray,
    harvest_date: Int,
    quantity_kg: Int,
    quality_grade: Int,
    moisture_level: Int,
    harvester: PubKeyHash,
  }
}

// Certificación
pub type Certification {
  Certification {
    cert_id: ByteArray,
    cert_type: CertificationType,
    lot_id: ByteArray,
    issued_by: PubKeyHash,
    issue_date: Int,
    expiry_date: Int,
    verified: Bool,
  }
}

// Información del lote
pub type LotInfo {
  LotInfo {
    lot_id: ByteArray,
    status: PlantationStatus,
    plantation_date: Int,
    location: Location,
    certifications: List<CertificationType>,
    harvest_records: List<HarvestRecord>,
  }
}

// Datum principal del contrato
pub type TraceabilityDatum {
  TraceabilityDatum {
    lot: LotInfo,
    current_owner: PubKeyHash,
    creation_date: Int,
  }
}

// Redeemers para diferentes acciones
pub type TraceabilityRedeemer {
  UpdateStatus { new_status: PlantationStatus }
  AddHarvest { harvest: HarvestRecord }
  AddCertification { certification: Certification }
  TransferOwnership { new_owner: PubKeyHash }
  UpdateLocation { new_location: Location }
}
