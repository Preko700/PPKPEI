# PPKPEI - Gestor de Préstamos iOS

Una aplicación iOS nativa desarrollada en SwiftUI para gestionar préstamos personales con interfaz intuitiva y funcionalidades completas.

## 🚀 Características Principales

### ✨ Funcionalidades Core
- **Dashboard intuitivo** con vista de todas las personas y sus deudas
- **Gestión de personas** - Solo requiere el nombre, interfaz simple
- **Múltiples préstamos** por persona con seguimiento independiente
- **Cálculo automático de intereses** basado en tiempo transcurrido
- **Edición manual de deudas** - Aumentar, disminuir o cancelar préstamos
- **Historial de pagos** con fecha, hora y notas opcionales
- **Detección de préstamos vencidos** con alertas visuales

### 📱 Interfaz de Usuario
- **Diseño nativo iOS** con SwiftUI
- **Navegación intuitiva** con botón + para agregar elementos
- **Formularios simples** para entrada manual de datos
- **Vista de tablero** mostrando nombres y información clave
- **Colores intuitivos** (rojo para vencido, verde para pagos, etc.)

### 🔔 Notificaciones (Bonus)
- **Recordatorios de vencimiento** automáticos
- **Alertas de préstamos vencidos** 
- **Notificaciones programables** para fechas de pago

### 💾 Persistencia de Datos
- **Core Data** para almacenamiento local
- **Datos seguros** almacenados en el dispositivo
- **Backup automático** con iCloud (si está habilitado)

## 📋 Estructura de Datos

### Persona
- Nombre (único campo requerido)
- Fecha de creación
- Lista de préstamos asociados

### Préstamo
- Monto inicial
- Porcentaje de interés anual
- Fecha de inicio (automática)
- Fecha de vencimiento
- Estado (activo/cancelado)
- Monto de deuda personalizable
- Historial de pagos

### Pago
- Monto del pago
- Fecha y hora
- Notas opcionales
- Asociado a un préstamo específico

## 🎯 Casos de Uso

### Flujo Principal
1. **Agregar persona nueva**: Toque el botón + en el dashboard
2. **Crear primer préstamo**: Complete el formulario con monto, interés y fecha de vencimiento
3. **Ver detalles**: Toque la persona en el dashboard para ver todos sus préstamos
4. **Registrar pagos**: Use "Agregar Pago" en cualquier préstamo activo
5. **Editar deuda**: Use "Editar Deuda" para modificar el monto o cancelar

### Gestión Avanzada
- **Múltiples préstamos**: Agregue nuevos préstamos a personas existentes
- **Seguimiento de vencimientos**: El app muestra automáticamente préstamos vencidos
- **Historial completo**: Vea todos los pagos realizados con fechas
- **Personalización**: Modifique manualmente las deudas según necesidades

## 🛠 Instalación y Desarrollo

### Requisitos
- Xcode 15.0 o superior
- iOS 17.0 o superior
- macOS Ventura o superior

### Abrir el Proyecto
1. Clone este repositorio
2. Abra `LoanManager.xcodeproj` en Xcode
3. Seleccione un simulador o dispositivo iOS
4. Presione ⌘+R para compilar y ejecutar

### Estructura del Proyecto
```
LoanManager/
├── Models/              # Modelos de datos Core Data
│   ├── Person.swift     # Modelo de persona
│   ├── Loan.swift       # Modelo de préstamo
│   └── Payment.swift    # Modelo de pago
├── Views/               # Vistas SwiftUI
│   ├── DashboardView.swift      # Vista principal
│   ├── AddPersonView.swift      # Formulario nueva persona
│   ├── PersonDetailView.swift   # Detalles de persona
│   ├── AddLoanView.swift        # Formulario nuevo préstamo
│   └── AddPaymentView.swift     # Formulario nuevo pago
├── LoanManagerApp.swift         # Punto de entrada de la app
├── ContentView.swift            # Vista contenedora principal
├── Persistence.swift            # Configuración Core Data
├── NotificationManager.swift    # Gestor de notificaciones
└── LoanManager.xcdatamodeld    # Modelo de datos Core Data
```

## 📱 Capturas de Pantalla

### Dashboard Principal
- Lista de personas con deudas totales
- Indicadores visuales de préstamos vencidos
- Botón + para agregar nuevas personas

### Detalle de Persona
- Resumen total de deudas
- Lista de préstamos activos
- Botones para agregar pagos y editar deudas
- Historial completo de préstamos

### Formularios
- Entrada simple y directa de datos
- Validación automática de campos
- Interfaz nativa iOS con DatePicker

## 🔧 Configuración Personalizada

### Modificar Cálculo de Intereses
El interés se calcula automáticamente usando la fórmula:
```swift
let interest = initialAmount * (interestRate / 100) * (days / 365)
let currentDebt = initialAmount + interest - totalPayments
```

### Personalizar Notificaciones
Las notificaciones se programan automáticamente para:
- Fecha de vencimiento del préstamo
- Recordatorios de préstamos vencidos

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia Apache 2.0 - vea el archivo [LICENSE](LICENSE) para más detalles.

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Cree una rama para su característica (`git checkout -b feature/AmazingFeature`)
3. Commit sus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abra un Pull Request

## 💡 Características Futuras

- [ ] Exportar reportes en PDF
- [ ] Backup y sincronización en la nube
- [ ] Calculadora de interés compuesto
- [ ] Gráficos de tendencias de pagos
- [ ] Recordatorios personalizables
- [ ] Modo oscuro mejorado
- [ ] Apple Watch companion app

---

**Desarrollado con ❤️ usando SwiftUI y Core Data**