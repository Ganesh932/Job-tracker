# Job Tracker

A simple iPhone-first job application tracker.

## Current builds

### Native iPhone app
The native SwiftUI MVP is in `ios/JobTrackerApp/`.

It includes:

- Dashboard counts
- Application search and status filter
- Company and job title
- LinkedIn / Naukri / Other source
- Applied date
- Recruiter name, email and phone
- Recruiter contacted date
- Location and job URL
- Notes
- Status updates
- Local persistence with SwiftData

See [`ios/README.md`](ios/README.md) for the Xcode setup and next steps.

### iPhone web/PWA
The existing GitHub Pages version remains available for quick testing. It stores applications locally on the device. Automatic Gmail/LinkedIn/Naukri status updates require a secure backend and supported OAuth/API integrations.

## Product roadmap

1. Native iPhone MVP
2. Gmail OAuth + automatic job-email detection
3. AI extraction and duplicate matching
4. Push notifications
5. Supported LinkedIn/Naukri integrations where official access permits
6. Secure backend sync and analytics

Never store Gmail, LinkedIn or Naukri passwords or API secrets in the app or repository.
