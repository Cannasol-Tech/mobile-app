# External APIs

## Twilio SMS API

- **Purpose:** Send SMS notifications for critical alerts when push notifications are insufficient
- **Documentation:** <https://www.twilio.com/docs/sms>
- **Base URL(s):** <https://api.twilio.com/2010-04-01/>
- **Authentication:** Basic Auth with Account SID and Auth Token
- **Rate Limits:** 1 message per second (default), configurable

**Key Endpoints Used:**

- `POST /Accounts/{AccountSid}/Messages.json` - Send SMS message

**Integration Notes:** Used for critical alerts only to minimize costs. Integrated via Cloud Functions with retry logic and delivery status tracking.

## SendGrid Email API

- **Purpose:** Send email notifications for alerts, reports, and system communications
- **Documentation:** <https://docs.sendgrid.com/api-reference>
- **Base URL(s):** <https://api.sendgrid.com/v3/>
- **Authentication:** Bearer token (API Key)
- **Rate Limits:** 600 requests per minute

**Key Endpoints Used:**

- `POST /mail/send` - Send email with templates
- `GET /templates` - Retrieve email templates

**Integration Notes:** Used for non-critical notifications and scheduled reports. Templates managed in SendGrid dashboard for easy updates.

## Weather API (OpenWeatherMap)

- **Purpose:** Correlate environmental conditions with external weather data for better insights
- **Documentation:** <https://openweathermap.org/api>
- **Base URL(s):** <https://api.openweathermap.org/data/2.5/>
- **Authentication:** API Key in query parameter
- **Rate Limits:** 1,000 calls per day (free tier)

**Key Endpoints Used:**

- `GET /weather` - Current weather data
- `GET /forecast` - 5-day weather forecast

**Integration Notes:** Optional integration for advanced analytics. Data stored in BigQuery for correlation analysis with facility conditions.
