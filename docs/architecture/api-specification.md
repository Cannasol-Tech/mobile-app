# API Specification

## REST API Specification

```yaml
openapi: 3.0.0
info:
  title: Cannasol Technologies API
  version: 1.0.0
  description: Firebase Cloud Functions API for Industrial Automation IO Config/Monitoring System
servers:
  - url: https://us-central1-cannasol-tech.cloudfunctions.net
    description: Production Firebase Functions
  - url: http://localhost:5001/cannasol-tech/us-central1
    description: Local development server

paths:
  /api/facilities:
    get:
      summary: Get user's accessible facilities
      security:
        - FirebaseAuth: []
      responses:
        '200':
          description: List of facilities
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Facility'
    post:
      summary: Create new facility
      security:
        - FirebaseAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateFacilityRequest'
      responses:
        '201':
          description: Facility created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Facility'

  /api/facilities/{facilityId}/environments:
    get:
      summary: Get environments for facility
      security:
        - FirebaseAuth: []
      parameters:
        - name: facilityId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: List of environments
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Environment'

  /api/environments/{environmentId}/readings:
    get:
      summary: Get sensor readings for environment
      security:
        - FirebaseAuth: []
      parameters:
        - name: environmentId
          in: path
          required: true
          schema:
            type: string
        - name: startTime
          in: query
          schema:
            type: string
            format: date-time
        - name: endTime
          in: query
          schema:
            type: string
            format: date-time
        - name: sensorType
          in: query
          schema:
            type: string
            enum: [temperature, humidity, co2, light, soil_moisture, ph]
      responses:
        '200':
          description: Sensor readings
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/SensorReading'

  /api/alerts:
    get:
      summary: Get alerts for user's facilities
      security:
        - FirebaseAuth: []
      parameters:
        - name: status
          in: query
          schema:
            type: string
            enum: [active, acknowledged, resolved, suppressed]
        - name: severity
          in: query
          schema:
            type: string
            enum: [low, medium, high, critical]
      responses:
        '200':
          description: List of alerts
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Alert'

  /api/alerts/{alertId}/acknowledge:
    post:
      summary: Acknowledge an alert
      security:
        - FirebaseAuth: []
      parameters:
        - name: alertId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Alert acknowledged
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Alert'

components:
  securitySchemes:
    FirebaseAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
  schemas:
    Facility:
      type: object
      properties:
        id:
          type: string
        name:
          type: string
        address:
          $ref: '#/components/schemas/Address'
        timezone:
          type: string
        environments:
          type: array
          items:
            type: string
        status:
          type: string
          enum: [active, maintenance, offline]
    Environment:
      type: object
      properties:
        id:
          type: string
        facilityId:
          type: string
        name:
          type: string
        type:
          type: string
          enum: [vegetative, flowering, drying, storage]
        currentConditions:
          $ref: '#/components/schemas/EnvironmentConditions'
        status:
          type: string
          enum: [optimal, warning, critical, offline]
    SensorReading:
      type: object
      properties:
        id:
          type: string
        deviceId:
          type: string
        environmentId:
          type: string
        timestamp:
          type: string
          format: date-time
        sensorType:
          type: string
          enum: [temperature, humidity, co2, light, soil_moisture, ph]
        value:
          type: number
        unit:
          type: string
        quality:
          type: number
          minimum: 0
          maximum: 1
    Alert:
      type: object
      properties:
        id:
          type: string
        facilityId:
          type: string
        environmentId:
          type: string
        type:
          type: string
          enum: [environmental, device, security, system]
        severity:
          type: string
          enum: [low, medium, high, critical]
        message:
          type: string
        status:
          type: string
          enum: [active, acknowledged, resolved, suppressed]
        triggeredAt:
          type: string
          format: date-time
```
