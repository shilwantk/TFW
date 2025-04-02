//
//  MarketPlaceRoutinesView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import ZalaAPI

struct MarketPlaceRoutinesView: View {    
    @State var  superUserOrgId: String
    @State var superUser: SuperUser
    @State var service: RoutineService = RoutineService()
    @Binding var isSubscribed: Bool
    
    var body: some View {
        VStack {
            if service.routines.isEmpty {
                ZalaEmptyView(title: "No Routines")
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(service.routines, id:\.id) { routine in
                            NavigationLink {
                                RoutineDetailView(superUser: superUser, 
                                                  orgId: routine.organizationId!,
                                                  isSubscribed: isSubscribed, 
                                                  routineId: routine.id!,
                                                  state: .marketplace)
                            } label: {
                                RoutinesCellView(routine: routine, subscription: true)
                            }
                        }
                    }
                }
            }
            Spacer()
            if !isSubscribed {
                SubscriptionButtonView(superUser: superUser, isSubscribed: $isSubscribed)
            }
        }
        .onAppear(perform: {
            service.fetchRoutinesFor(orgID: superUserOrgId, superUser: superUser.id!)
        })
    }
}
