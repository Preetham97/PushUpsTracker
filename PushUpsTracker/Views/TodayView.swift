//
//  TodayView.swift
//  PushUpsTracker
//
//  Created by Preetham Akhil Bhuma on 3/22/26.
//

import SwiftUI

struct TodayView: View {
    var viewModel: PushUpViewModel

    @State private var animateCount = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                // Date
                VStack(spacing: 4) {
                    Text(Date.now.formatted(.dateTime.weekday(.wide)))
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                // Count display
                VStack(spacing: 8) {
                    Text("\(viewModel.todayCount)")
                        .font(.system(size: 96, weight: .bold, design: .rounded))
                        .contentTransition(.numericText())
                        .animation(.snappy, value: viewModel.todayCount)
                    Text("push-ups today")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                // Streak
                if viewModel.currentStreak > 1 {
                    Label("\(viewModel.currentStreak)-day streak", systemImage: "flame.fill")
                        .font(.headline)
                        .foregroundStyle(.orange)
                }

                Spacer()

                // Buttons
                HStack(spacing: 20) {
                    Button {
                        viewModel.subtractPushUps(5)
                    } label: {
                        Text("-5")
                            .font(.title2.bold())
                            .frame(width: 56, height: 56)
                            .background(.gray.opacity(0.2), in: Circle())
                    }
                    .disabled(viewModel.todayCount == 0)

                    Button {
                        viewModel.subtractPushUps()
                    } label: {
                        Image(systemName: "minus")
                            .font(.title2.bold())
                            .frame(width: 56, height: 56)
                            .background(.gray.opacity(0.2), in: Circle())
                    }
                    .disabled(viewModel.todayCount == 0)

                    Button {
                        viewModel.addPushUps()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 80, height: 80)
                            .background(.blue, in: Circle())
                            .shadow(color: .blue.opacity(0.4), radius: 8, y: 4)
                    }
                    .sensoryFeedback(.impact, trigger: viewModel.todayCount)

                    Button {
                        viewModel.addPushUps(5)
                    } label: {
                        Text("+5")
                            .font(.title2.bold())
                            .frame(width: 56, height: 56)
                            .background(.blue.opacity(0.15), in: Circle())
                    }
                }

                Spacer()
                    .frame(height: 40)
            }
            .navigationTitle("Today")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}
