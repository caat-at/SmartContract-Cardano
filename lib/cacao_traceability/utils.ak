use cacao_traceability/types.{Location}

// Valida si una fecha de cosecha es posterior a la fecha de plantación
pub fn is_harvest_date_valid(plantation_date: Int, harvest_date: Int) -> Bool {
  harvest_date > plantation_date && harvest_date > plantation_date + 365 * 24 * 60 * 60
  // Al menos 1 año después
}

// Valida coordenadas geográficas
pub fn validate_location(location: Location) -> Bool {
  // Latitud entre -90 y 90 grados (en formato de enteros * 1000000)
  location.latitude >= -90000000 && location.latitude <= 90000000 && // Longitud entre -180 y 180 grados (en formato de enteros * 1000000)  
  location.longitude >= -180000000 && location.longitude <= 180000000 && // Nombre de la finca no vacío (ByteArray no es #"")
  location.farm_name != #"" && // Región no vacía (ByteArray no es #"")
  location.region != #""
}

// Valida si un grado de calidad está en rango válido
pub fn validate_quality_grade(grade: Int) -> Bool {
  grade >= 1 && grade <= 10
}

// Valida si un nivel de humedad está en rango válido
pub fn validate_moisture_level(moisture: Int) -> Bool {
  moisture >= 0 && moisture <= 100
}

// Función auxiliar para verificar si un ByteArray está vacío
pub fn is_empty_bytearray(ba: ByteArray) -> Bool {
  ba == #""
}
