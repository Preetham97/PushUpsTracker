//
//  ContentView.swift
//  PushUpsTracker
//
//  Created by Preetham Akhil Bhuma on 3/22/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: PushUpViewModel?

    var body: some View {
        Group {
            if let viewModel {
                TabView {
                    TodayView(viewModel: viewModel)
                        .tabItem {
                            Label("Today", systemImage: "figure.strengthtraining.traditional")
                        }

                    CalendarView(viewModel: viewModel)
                        .tabItem {
                            Label("Calendar", systemImage: "calendar")
                        }

                    HistoryView(viewModel: viewModel)
                        .tabItem {
                            Label("History", systemImage: "list.bullet")
                        }
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = PushUpViewModel(modelContext: modelContext)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: PushUpDay.self, inMemory: true)
}
