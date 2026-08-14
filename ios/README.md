# Job Tracker — native iPhone app

This folder contains the first native SwiftUI build for the Job Tracker.

## What is included

- Simple iPhone-first dashboard
- Application list with search and status filter
- Add application form
- Company name and job title
- LinkedIn / Naukri / Other source
- Applied date
- Recruiter name
- Recruiter email
- Recruiter phone
- Contacted date
- Job location and URL
- Notes
- Status updates
- Local persistent storage using SwiftData
- Tap recruiter email/phone to contact them

The design intentionally keeps the main flow simple: **Home → Applications → Details → Add**.

## Technology

- Swift
- SwiftUI
- SwiftData
- iOS 17+

Apple recommends SwiftUI for new Apple-platform apps and provides interactive previews in Xcode. See Apple's SwiftUI documentation for current setup guidance.

## Create the Xcode project

1. On a Mac, install the current Xcode version from the Mac App Store or Apple Developer site.
2. Open Xcode → File → New → Project.
3. Choose **iOS → App**.
4. Product Name: `JobTracker`
5. Interface: `SwiftUI`
6. Language: `Swift`
7. Organization Identifier: `com.ganesh932`
8. Deployment Target: iOS 17.0 or later.
9. Save the project locally.
10. Replace the generated Swift files with the files in this folder:
    - `JobTrackerApp.swift`
    - `JobApplication.swift`
    - `ContentView.swift`
11. Build and run in the iPhone 12 simulator first.
12. Then connect your iPhone 12, select it as the run destination, and run the app.

## Important

The current native version is the local-first MVP. It does **not** yet connect to Gmail, LinkedIn, or Naukri. Those integrations should be added through a secure backend and supported OAuth/API mechanisms. Never put Gmail, LinkedIn, or Naukri passwords in the iPhone app or GitHub repository.

## Next build stages

1. Gmail OAuth + job-email detection.
2. Automatic extraction of company, role, recruiter, contact date and status from job emails.
3. Duplicate application matching.
4. Push notifications for status changes and interviews.
5. Supported LinkedIn/Naukri integrations where official access permits it.
6. Backend sync so the same data is available after reinstalling the app.
