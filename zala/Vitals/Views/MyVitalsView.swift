//
//  MyVitalsView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct MyVitalsView: View {
    
    @Environment(VitalsService.self) var service
    @Environment(AccountService.self) var accountService
    @State private var showConfig: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Latest Vitals")
                    .style(size: .x22, weight: .w800)
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(service.latestData, id:\.self) { vital in
                            VitalCellView(key:vital.metric?.title ?? "Vital",
                                          value: vital.values?.last,
                                          unit: vital.displayUnits?.last,
                                          datetime: vital.formattedCreated())
                            if service.latestData.last != vital {
                                Divider().background(.gray).padding([.top, .bottom], 5)
                            }
                        }
                    }
                }
                Spacer()
                BorderedButton(title: "CONFIGURE VITALS") {
                    showConfig.toggle()
                }.padding(.top)
            }.padding()
        }
        .fullScreenCover(isPresented: $showConfig, content: {
            NavigationStack {
                MyDashboardConfigurationView() {
                    service.fetchLatestVitals()
                }
                .environment(service)
                .environment(accountService)
            }
        })        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text("VITALS")
                    .style(size: .x18, weight: .w700)
            }
        })
        .onAppear(perform: {
            service.updateUserMetrics(account: accountService.account)
        })
        
    }
}

#Preview {
    NavigationStack {
        MyVitalsView()
    }
}
