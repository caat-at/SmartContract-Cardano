# 🍫 Sistema de Trazabilidad de Cacao

Smart contract desarrollado en Aiken para la trazabilidad completa de cultivos de cacao en la blockchain de Cardano, desde la plantación hasta el procesamiento.

## 📋 Descripción

Este proyecto implementa un sistema descentralizado de trazabilidad para el cultivo de cacao, permitiendo rastrear cada etapa del proceso productivo de manera transparente e inmutable en la blockchain de Cardano.

## 🌱 Características

- **Seguimiento de ciclo completo**: Desde plantación hasta procesamiento
- **Gestión de certificaciones**: Orgánico, Fair Trade, Rainforest Alliance
- **Transferencia de propiedad**: Entre productores, cooperativas y procesadores  
- **Validación de calidad**: Control de humedad, grado de calidad y cantidad
- **Actualización de ubicación**: Trazabilidad geográfica del cultivo
- **Registro de cosechas**: Documentación detallada de cada cosecha

## 🛠️ Tecnologías

- **Aiken** - Lenguaje para smart contracts en Cardano
- **Cardano** - Blockchain
- **CBOR** - Serialización de datos
- **Preview/Preprod Testnet** - Red de pruebas

## 📁 Estructura del Proyecto


├── validators/

│ └── cacao_traceability.ak # Validador principal

├── lib/

│ └── cacao_traceability/

│ ├── types.ak # Definiciones de tipos
│ └── utils.ak # Funciones de utilidad

├── aiken.toml # Configuración del proyecto

└── README.md # Este archivo


## 🔄 Estados del Cultivo

1. **Plantado** (`Planted`) - Semillas plantadas
2. **Crecimiento** (`Growing`) - Plantas en desarrollo  
3. **Floración** (`Flowering`) - Plantas floreciendo
4. **Cosecha** (`Harvest`) - Listo para cosechar
5. **Certificada** (`Certified`) - Con certificaciones válidas
6. **Procesado** (`Processed`) - Procesamiento completado

## 🎯 Acciones Disponibles

### `UpdateStatus` - Actualizar Estado
Cambia el estado del cultivo siguiendo las transiciones válidas:

Plantado → Crecimiento → Floración → Cosecha → Certificada → Procesado


### `AddHarvest` - Agregar Cosecha
Registra nueva cosecha con:
- Cantidad en kilogramos
- Grado de calidad (1-10)
- Nivel de humedad (0-100%)
- Fecha de cosecha válida

### `AddCertification` - Agregar Certificación
Añade certificaciones verificadas:
- Orgánico
- Fair Trade  
- Rainforest Alliance
- Otras certificaciones personalizadas

### `TransferOwnership` - Transferir Propiedad
Transfiere propiedad entre:
- Productores
- Cooperativas
- Procesadores
- Compradores

### `UpdateLocation` - Actualizar Ubicación
Actualiza ubicación geográfica (solo en estados tempranos)

## 🚀 Instalación y Uso

### Prerrequisitos
- [Aiken](https://aiken-lang.org/) instalado
- PowerShell o terminal
- Git


### Construcción
aiken build - ### Generar dirección del contrato


### Validar código - aiken check


## 📋 Estructura de Datos

### TraceabilityDatum

pub type TraceabilityDatum {
lot: Lot,
current_owner: PubKeyHash,
created_at: Int,
updated_at: Int,
}


### Lot (Lote)
pub type Lot {
lot_id: ByteArray,
plantation_date: Int,
location: Location,
status: PlantationStatus,
harvest_records: List<HarvestRecord>,
certifications: List<Certification>,
}


### Validaciones de Seguridad

- ✅ **Transiciones de estado válidas**
- ✅ **Verificación de firmas requeridas**  
- ✅ **Prevención de certificaciones duplicadas**
- ✅ **Validación de rangos de calidad y humedad**
- ✅ **Control de fechas de cosecha**
- ✅ **Restricciones de actualización por estado**

## 🔧 Estado del Desarrollo

- [x] Tipos de datos definidos
- [x] Validador principal implementado
- [x] Validaciones de transición de estado
- [x] Gestión de certificaciones
- [x] Transferencia de propiedad
- [x] Actualización de ubicación
- [x] Registro de cosechas
- [x] Funciones de utilidad
- [ ] Cliente JavaScript implementado
- [ ] Interfaz de usuario web
- [ ] API REST
- [ ] Pruebas en testnet
- [ ] Documentación de API

## 🧪 Testing

Ejecutar tests
aiken test

Verificar código
aiken check

Formato del código
aiken fmt


## 🤝 Contribuir

1. Fork el repositorio
2. Crea una rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 👨‍💻 Autor

Carlos Aristizabal

- Ingeniero de Sistemas
- Desarrollador Blockchain
- GitHub: [@caat-at](https://github.com/caat-at)

## 🙏 Agradecimientos

- Comunidad Aiken
- Cardano Foundation
- Productores de cacao que inspiran este proyecto

---

⭐ **¡Dale una estrella si este proyecto te resulta útil para la trazabilidad agrícola!**

📧 **¿Tienes preguntas?** Abre un [issue](https://github.com/caat-at/cacao-traceability-system/issues)






