## NotificationService

### Purpose
Sends notifications via email and SMS

### Endpoints
- POST /notifications/send-email
- POST /notifications/send-sms  
- GET /notifications/{id}/status

### Data Models
**Notification**
- id: UUID
- type: string
- recipient: string
- message: string

**EmailRequest**
- email: string
- subject: string
- body: string

### External Dependencies
- SendGrid
- Twilio
- PostgreSQL