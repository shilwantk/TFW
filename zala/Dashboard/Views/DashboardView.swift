//
//  DashboardView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/21/24.
//

import SwiftUI

struct DashboardView: View {
    @Binding var didTapAdd: Bool
    @State private var showAccount: Bool = false
    @State private var showNotifications: Bool = false
    @State private var viewSelection = 0
    @Binding var state: SessionTransitionState
    @Binding var tabSelection: Int
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                Picker("", selection: $viewSelection) {
                    Text("My Zala").tag(0)
                    Text("My Insights").tag(1)
                }
                .pickerStyle(.segmented)
                ZStack(alignment: .bottomTrailing) {
                    if viewSelection == 0 {
                        MyZalaView(tabSelection: $tabSelection)
                    } else {
                        DashboardInsightsView()
                    }
                }                
            }
            CircleButtonView(action: $didTapAdd)
                .padding(.bottom)
        }
        .onReceive(NotificationCenter.default.publisher(for: .handleDeepLink)) { notification in }
        .toolbarWith(title: "DASHBOARD", session: $state) { type in }
    }
}
