//
//  CalendarView.swift
//  PushUpsTracker
//
//  Created by Preetham Akhil Bhuma on 3/22/26.
//

import SwiftUI

struct CalendarView: View {
    var viewModel: PushUpViewModel

    @State private var displayedMonth = Date.now

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdaySymbols = Calendar.current.shortWeekdaySymbols

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Month navigation
                HStack {
                    Button {
                        changeMonth(by: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.bold())
                    }

                    Spacer()

                    Text(displayedMonth.formatted(.dateTime.month(.wide).year()))
                        .font(.title2.bold())

                    Spacer()

                    Button {
                        changeMonth(by: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title3.bold())
                    }
                    .disabled(isCurrentMonth)
                }
                .padding(.horizontal)

                // Weekday headers
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(weekdaySymbols, id: \.self) { symbol in
                        Text(symbol)
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 8)

                // Day cells
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(daysInMonth, id: \.self) { date in
                        if let date {
                            DayCell(
                                day: calendar.component(.day, from: date),
                                count: countFor(date: date),
                                isToday: calendar.isDateInToday(date),
                                isFuture: date > Date.now
                            )
                        } else {
                            Color.clear
                                .frame(height: 56)
                        }
                    }
                }
                .padding(.horizontal, 8)

                // Monthly total
                let monthTotal = monthlyTotal
                if monthTotal > 0 {
                    HStack {
                        Label("Monthly Total", systemImage: "sum")
                        Spacer()
                        Text("\(monthTotal)")
                            .font(.title3.bold().monospacedDigit())
                    }
                    .padding()
                    .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Calendar")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }

    // MARK: - Helpers

    private var isCurrentMonth: Bool {
        calendar.isDate(displayedMonth, equalTo: .now, toGranularity: .month)
    }

    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            withAnimation {
                displayedMonth = newMonth
            }
        }
    }

    private var daysInMonth: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: displayedMonth),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth))
        else { return [] }

        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let leadingEmpty = firstWeekday - calendar.firstWeekday
        let adjustedLeading = (leadingEmpty + 7) % 7

        var days: [Date?] = Array(repeating: nil, count: adjustedLeading)

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }

        return days
    }

    private func countFor(date: Date) -> Int {
        let startOfDay = calendar.startOfDay(for: date)
        return viewModel.history.first { calendar.startOfDay(for: $0.date) == startOfDay }?.count ?? 0
    }

    private var monthlyTotal: Int {
        guard let interval = calendar.dateInterval(of: .month, for: displayedMonth) else { return 0 }
        return viewModel.history
            .filter { $0.date >= interval.start && $0.date < interval.end }
            .reduce(0) { $0 + $1.count }
    }
}

// MARK: - Day Cell

struct DayCell: View {
    let day: Int
    let count: Int
    let isToday: Bool
    let isFuture: Bool

    var body: some View {
        VStack(spacing: 2) {
            Text("\(day)")
                .font(.caption2.bold())
                .foregroundStyle(isFuture ? Color.gray.opacity(0.3) : (isToday ? Color.blue : Color.primary))

            if !isFuture {
                Text(count > 0 ? "\(count)" : "-")
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(count > 0 ? Color.blue : Color.gray.opacity(0.2))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
        )
    }

    private var backgroundColor: Color {
        if isToday {
            return .blue.opacity(0.12)
        } else if count > 0 {
            return .blue.opacity(min(0.05 + Double(count) / 200.0, 0.3))
        } else {
            return .clear
        }
    }
}
