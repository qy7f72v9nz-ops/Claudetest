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
            // Gradient background - Liquid Glass aesthetic
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.95, blue: 1.0),
                    Color(red: 0.95, green: 0.98, blue: 0.99)
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
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("Overtime Tracker")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)
            }

            Text("Track your postal delivery hours")
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
    }

    private var weekSelectorView: some View {
        HStack(spacing: 16) {
            Button(action: { viewModel.goToPreviousWeek() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.blue)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
            }

            VStack(spacing: 4) {
                Text(viewModel.currentWeek.weekRange)
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(.primary)

                Button(action: { viewModel.goToCurrentWeek() }) {
                    Text("Current Week")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(.blue)
                }
            }
            .frame(maxWidth: .infinity)

            Button(action: { viewModel.goToNextWeek() }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.blue)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
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
                        .foregroundStyle(.secondary)
                        .tracking(1.2)

                    Text("Monday - Sunday")
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                        .foregroundStyle(.secondary.opacity(0.8))
                }

                Spacer()

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.2f", viewModel.currentWeek.weeklyTotal))
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: viewModel.currentWeek.weeklyTotal > 0 ? [.blue, .cyan] : [.gray, .gray],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("hrs")
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }

            // Visual breakdown
            if viewModel.currentWeek.weeklyTotal > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 8, height: 8)
                        Text("Before: \(String(format: "%.2f", totalBefore)) hrs")
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Circle()
                            .fill(Color.cyan.opacity(0.3))
                            .frame(width: 8, height: 8)
                        Text("After: \(String(format: "%.2f", totalAfter)) hrs")
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.white.opacity(0.5), Color.white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, 20)
    }

    private var totalBefore: Double {
        viewModel.currentWeek.entries.reduce(0) { $0 + $1.overtimeBefore }
    }

    private var totalAfter: Double {
        viewModel.currentWeek.entries.reduce(0) { $0 + $1.overtimeAfter }
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
