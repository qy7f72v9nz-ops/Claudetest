//
//  DayEntryView.swift
//  OvertimeTracker
//
//  View for individual day overtime entry with Liquid Glass design
//

import SwiftUI

struct DayEntryView: View {
    let entry: OvertimeEntry
    let index: Int
    @EnvironmentObject var viewModel: OvertimeViewModel
    @State private var beforeHours: String
    @State private var afterHours: String
    @FocusState private var focusedField: Field?

    enum Field {
        case before, after
    }

    init(entry: OvertimeEntry, index: Int) {
        self.entry = entry
        self.index = index
        _beforeHours = State(initialValue: entry.minutesBefore > 0 ? String(entry.minutesBefore) : "")
        _afterHours = State(initialValue: entry.minutesAfter > 0 ? String(entry.minutesAfter) : "")
    }

    var body: some View {
        VStack(spacing: 0) {
            // Day header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.shortDayName)
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .tracking(0.5)

                    HStack(spacing: 6) {
                        Text(entry.dayNumber)
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundStyle(Color.black)

                        // Weather display
                        if let weather = entry.weather {
                            HStack(spacing: 4) {
                                Text(weather.emoji)
                                    .font(.system(size: 20))

                                Text(weather.temperatureFormatted)
                                    .font(.system(.caption, design: .rounded, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Spacer()

                // Daily total
                VStack(alignment: .trailing, spacing: 2) {
                    Text("TOTAL")
                        .font(.system(.caption2, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .tracking(0.5)

                    Text(entry.totalFormatted)
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(entry.totalMinutes > 0 ? .blue : .secondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            Divider()
                .background(Color.gray.opacity(0.2))

            // Input fields
            HStack(spacing: 12) {
                // Before contracted hours
                VStack(alignment: .leading, spacing: 8) {
                    Text("Before")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(.secondary)

                    HStack {
                        TextField("0", text: $beforeHours)
                            .keyboardType(.numberPad)
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.black)
                            .focused($focusedField, equals: .before)
                            .onChange(of: beforeHours) { _, newValue in
                                updateViewModel()
                            }

                        Text("min")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(focusedField == .before ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
                    )
                }

                // After contracted hours
                VStack(alignment: .leading, spacing: 8) {
                    Text("After")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(.secondary)

                    HStack {
                        TextField("0", text: $afterHours)
                            .keyboardType(.numberPad)
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.black)
                            .focused($focusedField, equals: .after)
                            .onChange(of: afterHours) { _, newValue in
                                updateViewModel()
                            }

                        Text("min")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(focusedField == .after ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }

    private func updateViewModel() {
        let before = Int(beforeHours) ?? 0
        let after = Int(afterHours) ?? 0
        viewModel.updateEntry(at: index, minutesBefore: before, minutesAfter: after)
    }
}
