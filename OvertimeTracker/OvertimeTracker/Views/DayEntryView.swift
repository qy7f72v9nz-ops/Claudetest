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
        _beforeHours = State(initialValue: entry.overtimeBefore > 0 ? String(format: "%.2f", entry.overtimeBefore) : "")
        _afterHours = State(initialValue: entry.overtimeAfter > 0 ? String(format: "%.2f", entry.overtimeAfter) : "")
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

                    Text(entry.dayNumber)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(.primary)
                }

                Spacer()

                // Daily total
                VStack(alignment: .trailing, spacing: 2) {
                    Text("TOTAL")
                        .font(.system(.caption2, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .tracking(0.5)

                    Text(String(format: "%.2f", entry.totalDaily))
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(entry.totalDaily > 0 ? .blue : .secondary)
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
                        TextField("0.00", text: $beforeHours)
                            .keyboardType(.decimalPad)
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .focused($focusedField, equals: .before)
                            .onChange(of: beforeHours) { _, newValue in
                                updateViewModel()
                            }

                        Text("hrs")
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
                        TextField("0.00", text: $afterHours)
                            .keyboardType(.decimalPad)
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .focused($focusedField, equals: .after)
                            .onChange(of: afterHours) { _, newValue in
                                updateViewModel()
                            }

                        Text("hrs")
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
        let before = Double(beforeHours) ?? 0
        let after = Double(afterHours) ?? 0
        viewModel.updateEntry(at: index, overtimeBefore: before, overtimeAfter: after)
    }
}
