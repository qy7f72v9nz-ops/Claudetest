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
            // Clean Apple-style background
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.98, blue: 0.99),  // Very light gray-blue
                    Color(red: 0.96, green: 0.97, blue: 0.98),  // Subtle gradient
                    Color(red: 0.95, green: 0.96, blue: 0.97)   // Light gray
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
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.0, green: 0.48, blue: 1.0),   // Apple blue
                                Color(red: 0.0, green: 0.6, blue: 1.0)     // Lighter blue
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("Overtime Tracker")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.black)
            }

            Text("Track your postal delivery hours")
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundStyle(Color.black.opacity(0.6))
        }
        .padding(.horizontal, 20)
    }

    private var weekSelectorView: some View {
        HStack(spacing: 16) {
            Button(action: { viewModel.goToPreviousWeek() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(red: 0.0, green: 0.48, blue: 1.0))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                    )
            }

            VStack(spacing: 4) {
                Text(viewModel.currentWeek.weekRange)
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color.black)

                Button(action: { viewModel.goToCurrentWeek() }) {
                    Text("Current Week")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(Color(red: 0.0, green: 0.48, blue: 1.0))
                }
            }
            .frame(maxWidth: .infinity)

            Button(action: { viewModel.goToNextWeek() }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(red: 0.0, green: 0.48, blue: 1.0))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
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
                                    Color(red: 0.0, green: 0.48, blue: 1.0),
                                    Color(red: 0.0, green: 0.6, blue: 1.0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .tracking(1.2)

                    Text("Monday - Sunday")
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                        .foregroundStyle(Color.black.opacity(0.5))
                }

                Spacer()

                Text(viewModel.currentWeek.weeklyTotalFormatted)
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(
                        viewModel.currentWeek.weeklyTotalMinutes > 0 ?
                            LinearGradient(
                                colors: [
                                    Color(red: 0.0, green: 0.48, blue: 1.0),
                                    Color(red: 0.0, green: 0.6, blue: 1.0)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [Color.black.opacity(0.3), Color.black.opacity(0.3)],
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
                                Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.4)
                            )
                            .frame(width: 8, height: 8)
                        Text("Before: \(formatMinutes(viewModel.currentWeek.totalMinutesBefore))")
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(Color.black.opacity(0.6))
                    }

                    HStack {
                        Circle()
                            .fill(
                                Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.7)
                            )
                            .frame(width: 8, height: 8)
                        Text("After: \(formatMinutes(viewModel.currentWeek.totalMinutesAfter))")
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(Color.black.opacity(0.6))
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(24)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)

                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(
                        Color.black.opacity(0.06),
                        lineWidth: 1
                    )
            }
            .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
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
