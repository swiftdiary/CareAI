//
//  AppointmentDetailView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 18/02/24.
//

import SwiftUI

struct AppointmentDetailView: View {
    @StateObject private var appointmentDetailVM = AppointmentDetailViewModel()
    @State private var isShowModal: Bool = false
    @State private var modalImage: String = ""
    let appointment: Appointment
    
    
    var body: some View {
        VStack {
            ScrollView {
                DoctorInfoSection()
                DateSection()
                ReasonSection()
                AttachmentsSection()
                PaymentDetailsSection()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Appointment")
                    .font(.title2.bold())
            }
        }
        .navigationDestination(isPresented: $isShowModal) {
            AsyncImage(url: URL(string: modalImage)) { img in
                img
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
            } placeholder: {
                ProgressView()
            }

        }
    }
    
    @ViewBuilder
    func DoctorInfoSection() -> some View {
        HStack(alignment: .top) {
            Image(.doctor)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                
            VStack(alignment: .leading) {
                Text(appointment.doctor ?? "Dr. Dre")
                    .font(.headline)
                Text("Cardiologist")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                HStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                    Text("4.9")
                }
                .font(.subheadline)
                .foregroundStyle(Color.accentColor)
                .padding(4.0)
                .background {
                    RoundedRectangle(cornerRadius: 6.0)
                        .fill(Color.accentColor.opacity(0.3))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 160)
        }
        .background {
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color.accentColor)
                .shadow(radius: 15)
        }
        .padding()
    }
    
    @ViewBuilder
    func DateSection() -> some View {
        VStack(alignment: .leading) {
            Text("Date")
                .font(.title2.bold())
                .padding(.horizontal, 10)
            Rectangle()
                .fill(Color.accentColor)
                .frame(height: 2)
            if let dateTime = appointment.dateTime, let date = dateTime.toDate() {
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(Color.accentColor)
                    Text(date.format("EEEE, MMM d, yyyy | h:mm a"))
                        .font(.headline)
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    func ReasonSection() -> some View {
        VStack(alignment: .leading) {
            Text("Reason")
                .font(.title2.bold())
                .padding(.horizontal, 10)
            Rectangle()
                .fill(Color.accentColor)
                .frame(height: 2)
            if let symptomsDesc = appointment.symptomsDesc {
                HStack {
                    Image(systemName: "newspaper.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(Color.accentColor)
                    Text(symptomsDesc)
                        .font(.headline)
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    func AttachmentsSection() -> some View {
        VStack(alignment: .leading) {
            Text("Attachments")
                .font(.title2.bold())
                .padding(.horizontal, 10)
            Rectangle()
                .fill(Color.accentColor)
                .frame(height: 2)
            HStack {
                if let mriImage = appointment.mriImage {
                    HStack {
                        Image(systemName: "person.and.background.dotted")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.accentColor)
                        Text("MRI Scan")
                            .font(.headline)
                    }
                    .padding()
                    .onTapGesture(perform: {
                        modalImage = mriImage
                        isShowModal = true
                    })
                }
                Spacer()
                if let xRayImage = appointment.xRayImage {
                    HStack {
                        Image(systemName: "scanner.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.accentColor)
                        Text("X-Ray Scan")
                            .font(.headline)
                    }
                    .padding()
                    .onTapGesture(perform: {
                        modalImage = xRayImage
                        isShowModal = true
                    })
                }
            }
        }
    }
    
    @ViewBuilder
    func PaymentDetailsSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Payment Details")
                .font(.title2.bold())
            HStack {
                Text("Consultation:")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("$60")
            }
            HStack {
                Text("Applied Discount:")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("$0")
            }
            HStack {
                Text("Total:")
                    .font(.headline)
                Spacer()
                Text("$60")
                    .foregroundStyle(Color.accentColor)
            }
        }
        .padding(10)
    }
}

#Preview {
    NavigationStack {
        AppointmentDetailView(appointment: Appointment(id: 3))
    }
}
