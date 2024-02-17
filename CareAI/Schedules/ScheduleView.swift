//
//  ScheduleView.swift
//  CareAI
//
//  Created by Akbar Khusanbaev on 17/02/24.
//

import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject private var navigation: AppNavigation
    @StateObject private var schedulesVM = SchedulesViewModel()
    @Namespace var namespace
    
    var body: some View {
        VStack {
            ScrollView {
                TopSegmentedControl()
                AppointmentsSection()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Schedules")
                    .font(.title2.bold())
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(.notificationIcon)
                    .resizable()
                    .scaledToFit()
            }
        }
        .task {
            do {
                try await schedulesVM.getSchedules()
            } catch {
                print(error)
            }
        }
    }
    
    @ViewBuilder
    func TopSegmentedControl() -> some View {
        HStack(spacing: 0) {
            ForEach(ScheduleType.allCases, id: \.self) { type in
                Button(action: {
                    withAnimation(.bouncy) {
                        schedulesVM.selectedType = type
                    }
                }, label: {
                    Text(type.title)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background {
                            if schedulesVM.selectedType == type {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(Color.accentColor)
                                    .matchedGeometryEffect(id: "TopSegmentedControl", in: namespace)
                            }
                        }
                })
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.secondary.gradient)
        )
        .padding()
    }
    
    @ViewBuilder
    func AppointmentsSection() -> some View {
        ForEach(schedulesVM.appointments) {appointment in
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(appointment.doctor ?? "N/A")")
                            .font(.title2.bold())
                        Text("\(appointment.symptomsDesc ?? "a")")
                    }
                    Spacer()
                    Image(.doctor)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                }
                HStack {
                    if let dateTime = appointment.dateTime, let date = dateTime.toDate() {
                        HStack {
                            Image(systemName: "calendar")
                            Text(date.format())
                        }
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        HStack {
                            Image(systemName: "clock")
                            Text(date.format("hh:mm"))
                        }
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        Group {
                            HStack {
                                Circle()
                                    .fill(.green)
                                    .frame(width: 4, height: 4)
                                Text("Approved")
                            }
//                            if appointment.status == ScheduleType.approved.rawValue {
//                                HStack {
//                                    Circle()
//                                        .fill(.green)
//                                        .frame(width: 4, height: 4)
//                                    Text("Approved")
//                                }
//                            } else if appointment.status == ScheduleType.pending.rawValue {
//                                HStack {
//                                    Circle()
//                                        .fill(.yellow)
//                                        .frame(width: 4, height: 4)
//                                    Text("Pending")
//                                }
//                            } else {
//                                HStack {
//                                    Circle()
//                                        .fill(.red)
//                                        .frame(width: 4, height: 4)
//                                    Text("Canceled")
//                                }
//                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 0.3)
                    .foregroundStyle(Color.accentColor)
            }
            .padding(.horizontal)
            .onTapGesture {
                navigation.path.append(.appointmentDetail(appointment))
            }
        }
    }
}

#Preview {
    NavigationStack {
        ScheduleView()
            .environmentObject(AppNavigation())
    }
}
