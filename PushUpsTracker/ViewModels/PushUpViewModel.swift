//
//  PushUpViewModel.swift
//  PushUpsTracker
//
//  Created by Preetham Akhil Bhuma on 3/22/26.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
final class PushUpViewModel {
    private var modelContext: ModelContext

    var today: PushUpDay?
    var history: [PushUpDay] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchToday()
        fetchHistory()
    }

    var todayCount: Int {
        today?.count ?? 0
    }

    func addPushUps(_ amount: Int = 1) {
        ensureToday()
        today?.count += amount
        try? modelContext.save()
        fetchHistory()
    }

    func subtractPushUp() {
        guard let today, today.count > 0 else { return }
        today.count -= 1
        try? modelContext.save()
        fetchHistory()
    }

    func fetchToday() {
        let startOfDay = Calendar.current.startOfDay(for: .now)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = #Predicate<PushUpDay> { day in
            day.date >= startOfDay && day.date < endOfDay
        }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1

        today = try? modelContext.fetch(descriptor).first
    }

    func fetchHistory() {
        let descriptor = FetchDescriptor<PushUpDay>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        history = (try? modelContext.fetch(descriptor)) ?? []
    }

    private func ensureToday() {
        if today == nil {
            let newDay = PushUpDay()
            modelContext.insert(newDay)
            today = newDay
        }
    }

    // MARK: - Weekly Summary

    var thisWeekDays: [PushUpDay] {
        let calendar = Calendar.current
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: .now)?.start else {
            return []
        }
        return history.filter { $0.date >= weekStart }
    }

    var weeklyTotal: Int {
        thisWeekDays.reduce(0) { $0 + $1.count }
    }

    var weeklyAverage: Double {
        let days = thisWeekDays
        guard !days.isEmpty else { return 0 }
        return Double(weeklyTotal) / Double(days.count)
    }

    var bestDay: PushUpDay? {
        thisWeekDays.max(by: { $0.count < $1.count })
    }

    var currentStreak: Int {
        let calendar = Calendar.current
        let sorted = history
            .filter { $0.count > 0 }
            .sorted { $0.date > $1.date }

        var streak = 0
        var expectedDate = calendar.startOfDay(for: .now)

        for day in sorted {
            let dayDate = calendar.startOfDay(for: day.date)
            if dayDate == expectedDate {
                streak += 1
                expectedDate = calendar.date(byAdding: .day, value: -1, to: expectedDate)!
            } else if dayDate < expectedDate {
                break
            }
        }
        return streak
    }
}
