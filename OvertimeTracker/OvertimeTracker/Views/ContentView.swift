//
//  ContentView.swift
//  OvertimeTracker
//
//  Main view with Liquid Glass design language
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: OvertimeViewModel

    var body: some View {
        ZStack {
            // Royal Mail red gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.88, green: 0.0, blue: 0.0),    // Deep Royal Mail red
                    Color(red: 0.95, green: 0.20, blue: 0.20),  // Lighter red
                    Color(red: 1.0, green: 0.30, blue: 0.30)    // Soft red
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView

                    // Week selector
                    weekSelectorView

                    // Weekly total card
                    weeklyTotalView

                    // Daily entries
                    VStack(spacing: 16) {
                        ForEach(Array(viewModel.currentWeek.entries.enumerated()), id: \.element.id) { index, entry in
                            DayEntryView(entry: entry, index: index)
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 40)
                }
                .padding(.top, 20)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }

    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "clock.badge.checkmark.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.white)

                Text("Overtime Tracker")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.white)
            }

            Text("Track your postal delivery hours")
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.9))
        }
        .padding(.horizontal, 20)
    }

    private var weekSelectorView: some View {
        HStack(spacing: 16) {
            Button(action: { viewModel.goToPreviousWeek() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
            }

            VStack(spacing: 4) {
                Text(viewModel.currentWeek.weekRange)
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color.white)

                Button(action: { viewModel.goToCurrentWeek() }) {
                    Text("Current Week")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.9))
                }
            }
            .frame(maxWidth: .infinity)

            Button(action: { viewModel.goToNextWeek() }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
            }
        }
        .padding(.horizontal, 20)
    }

    private var weeklyTotalView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("WEEKLY TOTAL")
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.85, green: 0.0, blue: 0.0),
                                    Color(red: 1.0, green: 0.25, blue: 0.25)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .tracking(1.2)

                    Text("Monday - Sunday")
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                        .foregroundStyle(Color.black.opacity(0.6))
                }

                Spacer()

                Text(viewModel.currentWeek.weeklyTotalFormatted)
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(
                        viewModel.currentWeek.weeklyTotalMinutes > 0 ?
                            LinearGradient(
                                colors: [
                                    Color(red: 0.85, green: 0.0, blue: 0.0),
                                    Color(red: 1.0, green: 0.3, blue: 0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [Color.black.opacity(0.4), Color.black.opacity(0.4)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                    )
            }

            // Visual breakdown
            if viewModel.currentWeek.weeklyTotalMinutes > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.85, green: 0.0, blue: 0.0).opacity(0.5),
                                        Color(red: 1.0, green: 0.25, blue: 0.25).opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 8, height: 8)
                        Text("Before: \(formatMinutes(viewModel.currentWeek.totalMinutesBefore))")
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(Color.black.opacity(0.7))
                    }

                    HStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.85, green: 0.0, blue: 0.0).opacity(0.7),
                                        Color(red: 1.0, green: 0.25, blue: 0.25).opacity(0.5)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 8, height: 8)
                        Text("After: \(formatMinutes(viewModel.currentWeek.totalMinutesAfter))")
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(Color.black.opacity(0.7))
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(24)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)

                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, 20)
    }

    private func formatMinutes(_ minutes: Int) -> String {
        if minutes == 0 {
            return "0m"
        }
        let hours = minutes / 60
        let mins = minutes % 60

        if hours == 0 {
            return "\(mins)m"
        } else if mins == 0 {
            return "\(hours)h"
        } else {
            return "\(hours)h \(mins)m"
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Preview
#Preview {
    ContentView()
        .environmentObject(OvertimeViewModel())
}
