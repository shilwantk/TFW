//
//  RoutineComplianceDetailView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct RoutineComplianceDetailView: View {
    
    @State private var config: CalendarHeaderConfig = .day
    
    var body: some View {
        ScrollView {
            VStack {
                CalendarHeaderView(date: .constant(Date.now), config: $config)
                    .frame(minHeight: 55)
                
                Divider().background(.gray)
                MetaView(itemOne: MetaItem(title: "Compliance", subtitle: "96%", image: .pieGraph),
                         itemTwo: MetaItem(title: "Total Tally", subtitle: "34/36", image: .graphUp),
                         itemThree: MetaItem(title: "Streak", subtitle: "+7", image: .streak))
                .padding([.top, .bottom], 12)
                RoutineComplianceDetailCellView()
                RoutineComplianceDetailCellView()
                RoutineComplianceDetailCellView()
                Spacer()
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                ToolbarHeaderView(title: "Measure - Body Weight", 
                                  subtitle: "Weekly • 1 times • Mon, Wed, Fri • Anytime")
            }
        })
    }
}

#Preview {
    RoutineComplianceDetailView()
}
