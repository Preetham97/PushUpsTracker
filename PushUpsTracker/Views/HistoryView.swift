//
//  HistoryView.swift
//  PushUpsTracker
//
//  Created by Preetham Akhil Bhuma on 3/22/26.
//

import SwiftUI

struct HistoryView: View {
    var viewModel: PushUpViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.history.isEmpty {
                    ContentUnavailableView(
                        "No History Yet",
                        systemImage: "figure.strengthtraining.traditional",
                        description: Text("Start tracking push-ups and your history will appear here.")
                    )
                } else {
                    List {
                        // Weekly summary section
                        Section("This Week") {
                            WeeklySummaryRow(
                                title: "Total",
                                value: "\(viewModel.weeklyTotal)",
                                icon: "sum",
                                color: .blue
                            )
                            WeeklySummaryRow(
                                title: "Daily Average",
                                value: String(format: "%.1f", viewModel.weeklyAverage),
                                icon: "chart.bar.fill",
                                color: .green
                            )
                            if let best = viewModel.bestDay {
                                WeeklySummaryRow(
                                    title: "Best Day",
                                    value: "\(best.count) (\(best.dayOfWeek))",
                                    icon: "trophy.fill",
                                    color: .orange
                                )
                            }
                            if viewModel.currentStreak > 0 {
                                WeeklySummaryRow(
                                    title: "Streak",
                                    value: "\(viewModel.currentStreak) days",
                                    icon: "flame.fill",
                                    color: .red
                                )
                            }
                        }

                        // History list
                        Section("All Days") {
                            ForEach(viewModel.history) { day in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(day.formattedDate)
                                            .font(.body)
                                        Text(day.dayOfWeek)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text("\(day.count)")
                                        .font(.title2.bold().monospacedDigit())
                                        .foregroundStyle(day.count > 0 ? .primary : .secondary)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}

struct WeeklySummaryRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)
            Text(title)
            Spacer()
            Text(value)
                .font(.headline.monospacedDigit())
                .foregroundStyle(color)
        }
    }
}
