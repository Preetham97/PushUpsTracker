# PushUps Tracker

A simple iOS app to track your daily push-up count, built with SwiftUI and SwiftData.

## Features

- **Today View** — See today's date and push-up count with +1, +5, and -1 buttons. Includes haptic feedback and streak tracking.
- **Calendar View** — Monthly calendar grid showing push-up counts for each day. Navigate between months with arrow buttons. Days with push-ups are highlighted in blue (darker = more push-ups). Displays a monthly total at the bottom.
- **History View** — Weekly summary (total, daily average, best day, streak) and a scrollable list of all recorded days.
- **Data Persistence** — All data is stored locally on-device using SwiftData (SQLite). Your counts persist between app launches.

## Requirements

- iOS 17.0+
- Xcode 15+

## Architecture

The app follows the **MVVM** (Model-View-ViewModel) pattern:

```
PushUpsTracker/
├── PushUpsTrackerApp.swift        # App entry point, SwiftData container setup
├── ContentView.swift              # TabView with three tabs
├── Models/
│   └── PushUpDay.swift            # SwiftData model (date + count)
├── ViewModels/
│   └── PushUpViewModel.swift      # Business logic, stats, streak calculation
└── Views/
    ├── TodayView.swift            # Today's count and action buttons
    ├── CalendarView.swift         # Monthly calendar grid
    └── HistoryView.swift          # Weekly summary and full history list
```

## How It Works

- **PushUpDay** is a SwiftData `@Model` that stores a date and push-up count.
- **PushUpViewModel** manages all data operations — fetching today's record, adding/subtracting push-ups, computing weekly stats and streaks.
- Each day is stored as a separate record. The app creates a new record the first time you tap "+" on a given day.

## Getting Started

1. Open `PushUpsTracker.xcodeproj` in Xcode
2. Select an iPhone simulator (e.g. iPhone 16)
3. Press **Cmd + R** to build and run
