# README

Esta aplicación fue desarrollada como parte de un desafío, con el objetivo de crear una API para facilitar transacciones de compra y venta de Bitcoin.

## Detalles Técnicos
* Versión de Ruby: 3.1.3
* Versión de Rails: 7.1.3
* Base de datos: PostgreSQL

### API Coindesk Wrapper:

Se implementó un envoltorio (wrapper) para la API de Coindesk, permitiendo obtener el valor actual del Bitcoin en USD. Se utilizó la gema [`Faraday`](https://github.com/lostisland/faraday) 

### Manejo de Transacciones con SimpleCommand:

Se utilizó la gema [`SimpleCommand`](https://github.com/nebulab/simple_command) para separar la lógica de creación de transacciones en un comando, manteniendo un diseño claro y modular.

### Testing Integral con RSpec:

Se realizaron pruebas exhaustivas utilizando RSpec para modelos, solicitudes (requests), y el comando de creación de transacciones.

### Documentación con Swagger:

La documentación de la API se generó utilizando [`Swagger`](https://github.com/rswag/rswag). Puedes explorar y probar la API directamente desde la interfaz Swagger.

### Dockerización para Desarrollo:

La aplicación se dockerizó para facilitar el desarrollo, proporcionando un entorno consistente y portátil.

## Rutas de la API

### Transacciones

- **Obtener Transacciones:**
  - **Endpoint:** `/transactions`
  - **Método:** GET
  - **Descripción:** Recuperar una lista de transacciones para el usuario autenticado.
  - **Respuesta:** Array de transacciones.

- **Crear Transacción:**
  - **Endpoint:** `/transactions`
  - **Método:** POST
  - **Descripción:** Crear una nueva transacción para el usuario actual.
  - **Cuerpo de la Solicitud:**
    ```json
    {
      "sent_currency": "usd",
      "received_currency": "btc",
      "sent_amount": 100.0
    }
    ```
  - **Respuesta:** Detalles de la nueva transacción.

- **Obtener Transacción Específica:**
  - **Endpoint:** `/transactions/{id}`
  - **Método:** GET
  - **Descripción:** Recuperar detalles de una transacción específica para el usuario autenticado.
  - **Parámetros:**
    - `id` (Parámetro de Ruta): ID de la transacción a recuperar.
  - **Respuesta:** Detalles de la transacción específica.

### Precio del Bitcoin

- **Obtener Tasa de Bitcoin:**
  - **Endpoint:** `/prices/btc`
  - **Método:** GET
  - **Descripción:** Obtener la tasa actual de Bitcoin.
  - **Respuesta:** Detalles de la tasa actual de Bitcoin.
