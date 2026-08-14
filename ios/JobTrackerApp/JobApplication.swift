import Foundation
import SwiftData

@Model
final class JobApplication {
    var company: String
    var role: String
    var source: String
    var status: String
    var recruiterName: String
    var recruiterEmail: String
    var recruiterPhone: String
    var contactedDate: Date?
    var appliedDate: Date
    var location: String
    var jobURL: String
    var notes: String

    init(
        company: String,
        role: String,
        source: String = "Manual",
        status: String = "Applied",
        recruiterName: String = "",
        recruiterEmail: String = "",
        recruiterPhone: String = "",
        contactedDate: Date? = nil,
        appliedDate: Date = .now,
        location: String = "",
        jobURL: String = "",
        notes: String = ""
    ) {
        self.company = company
        self.role = role
        self.source = source
        self.status = status
        self.recruiterName = recruiterName
        self.recruiterEmail = recruiterEmail
        self.recruiterPhone = recruiterPhone
        self.contactedDate = contactedDate
        self.appliedDate = appliedDate
        self.location = location
        self.jobURL = jobURL
        self.notes = notes
    }
}

enum JobStatus: String, CaseIterable, Identifiable {
    case applied = "Applied"
    case viewed = "Application Viewed"
    case shortlisted = "Shortlisted"
    case contacted = "Recruiter Contacted"
    case interview = "Interview"
    case assessment = "Assessment"
    case offer = "Offer"
    case rejected = "Rejected"
    case withdrawn = "Withdrawn"

    var id: String { rawValue }
}
