import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JobApplication.appliedDate, order: .reverse) private var applications: [JobApplication]
    @State private var showingAdd = false
    @State private var searchText = ""
    @State private var selectedStatus = "All"

    private var filteredApplications: [JobApplication] {
        applications.filter { application in
            let matchesSearch = searchText.isEmpty ||
                application.company.localizedCaseInsensitiveContains(searchText) ||
                application.role.localizedCaseInsensitiveContains(searchText) ||
                application.recruiterName.localizedCaseInsensitiveContains(searchText)
            let matchesStatus = selectedStatus == "All" || application.status == selectedStatus
            return matchesSearch && matchesStatus
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 10) {
                        StatView(title: "Total", value: applications.count)
                        StatView(title: "Interviews", value: applications.filter { $0.status == JobStatus.interview.rawValue }.count)
                        StatView(title: "Offers", value: applications.filter { $0.status == JobStatus.offer.rawValue }.count)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    .listRowBackground(Color.clear)
                }

                Section {
                    Picker("Status", selection: $selectedStatus) {
                        Text("All").tag("All")
                        ForEach(JobStatus.allCases) { status in
                            Text(status.rawValue).tag(status.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Applications") {
                    if filteredApplications.isEmpty {
                        ContentUnavailableView("No applications", systemImage: "briefcase", description: Text("Tap + to add your first job application."))
                    } else {
                        ForEach(filteredApplications) { application in
                            NavigationLink {
                                ApplicationDetailView(application: application)
                            } label: {
                                ApplicationRow(application: application)
                            }
                        }
                        .onDelete(perform: deleteApplications)
                    }
                }
            }
            .navigationTitle("Job Tracker")
            .searchable(text: $searchText, prompt: "Company, role or recruiter")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add job application")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddApplicationView()
            }
        }
    }

    private func deleteApplications(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredApplications[index])
        }
    }
}

private struct StatView: View {
    let title: String
    let value: Int

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)").font(.title3.bold())
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct ApplicationRow: View {
    let application: JobApplication

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(application.company).font(.headline)
                Spacer()
                Text(application.status)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.12), in: Capsule())
                    .foregroundStyle(statusColor)
            }
            Text(application.role.isEmpty ? "Job application" : application.role)
                .foregroundStyle(.primary)
            HStack(spacing: 5) {
                Text(application.source)
                Text("•")
                Text(application.appliedDate.formatted(date: .abbreviated, time: .omitted))
                if !application.recruiterName.isEmpty {
                    Text("•")
                    Text(application.recruiterName)
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var statusColor: Color {
        switch application.status {
        case JobStatus.interview.rawValue, JobStatus.offer.rawValue: return .green
        case JobStatus.rejected.rawValue, JobStatus.withdrawn.rawValue: return .red
        case JobStatus.shortlisted.rawValue, JobStatus.contacted.rawValue: return .orange
        default: return .blue
        }
    }
}

struct AddApplicationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var company = ""
    @State private var role = ""
    @State private var source = "LinkedIn"
    @State private var status = JobStatus.applied.rawValue
    @State private var recruiterName = ""
    @State private var recruiterEmail = ""
    @State private var recruiterPhone = ""
    @State private var hasContacted = false
    @State private var contactedDate = Date.now
    @State private var appliedDate = Date.now
    @State private var location = ""
    @State private var jobURL = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Job") {
                    TextField("Company *", text: $company)
                    TextField("Job title", text: $role)
                    TextField("Location", text: $location)
                    Picker("Source", selection: $source) {
                        Text("LinkedIn").tag("LinkedIn")
                        Text("Naukri").tag("Naukri")
                        Text("Other").tag("Other")
                    }
                    Picker("Status", selection: $status) {
                        ForEach(JobStatus.allCases) { item in
                            Text(item.rawValue).tag(item.rawValue)
                        }
                    }
                    DatePicker("Applied date", selection: $appliedDate, displayedComponents: .date)
                }

                Section("Recruiter / Contact") {
                    TextField("Recruiter name", text: $recruiterName)
                    TextField("Email", text: $recruiterEmail)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Phone", text: $recruiterPhone)
                        .keyboardType(.phonePad)
                    Toggle("Recruiter contacted", isOn: $hasContacted)
                    if hasContacted {
                        DatePicker("Contacted date", selection: $contactedDate, displayedComponents: .date)
                    }
                }

                Section("Details") {
                    TextField("Job URL", text: $jobURL)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Application")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(company.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func save() {
        let application = JobApplication(
            company: company.trimmingCharacters(in: .whitespacesAndNewlines),
            role: role.trimmingCharacters(in: .whitespacesAndNewlines),
            source: source,
            status: status,
            recruiterName: recruiterName.trimmingCharacters(in: .whitespacesAndNewlines),
            recruiterEmail: recruiterEmail.trimmingCharacters(in: .whitespacesAndNewlines),
            recruiterPhone: recruiterPhone.trimmingCharacters(in: .whitespacesAndNewlines),
            contactedDate: hasContacted ? contactedDate : nil,
            appliedDate: appliedDate,
            location: location.trimmingCharacters(in: .whitespacesAndNewlines),
            jobURL: jobURL.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        modelContext.insert(application)
        dismiss()
    }
}

struct ApplicationDetailView: View {
    @Bindable var application: JobApplication

    var body: some View {
        List {
            Section("Application") {
                LabeledContent("Company", value: application.company)
                if !application.role.isEmpty { LabeledContent("Role", value: application.role) }
                LabeledContent("Source", value: application.source)
                LabeledContent("Status", value: application.status)
                LabeledContent("Applied", value: application.appliedDate.formatted(date: .abbreviated, time: .omitted))
                if !application.location.isEmpty { LabeledContent("Location", value: application.location) }
            }

            Section("Recruiter / Contact") {
                if !application.recruiterName.isEmpty { LabeledContent("Name", value: application.recruiterName) }
                if !application.recruiterEmail.isEmpty {
                    Link(destination: URL(string: "mailto:\(application.recruiterEmail)")!) {
                        LabeledContent("Email", value: application.recruiterEmail)
                    }
                }
                if !application.recruiterPhone.isEmpty {
                    Link(destination: URL(string: "tel:\(application.recruiterPhone.replacingOccurrences(of: " ", with: ""))")!) {
                        LabeledContent("Phone", value: application.recruiterPhone)
                    }
                }
                if let date = application.contactedDate {
                    LabeledContent("Contacted", value: date.formatted(date: .abbreviated, time: .omitted))
                } else {
                    Text("Not contacted yet").foregroundStyle(.secondary)
                }
            }

            Section("Update Status") {
                Picker("Status", selection: $application.status) {
                    ForEach(JobStatus.allCases) { status in
                        Text(status.rawValue).tag(status.rawValue)
                    }
                }
            }

            if !application.jobURL.isEmpty, let url = URL(string: application.jobURL) {
                Section {
                    Link("Open job posting", destination: url)
                }
            }

            if !application.notes.isEmpty {
                Section("Notes") { Text(application.notes) }
            }
        }
        .navigationTitle(application.company)
        .navigationBarTitleDisplayMode(.inline)
    }
}
