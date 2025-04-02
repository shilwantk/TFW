//
//  EventDetailView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct EventDetailView: View {
    @State var event: EventbriteEvent
    @State var showWebView: Bool = false
    var body: some View {
        VStack{
            ScrollView {
                VStack {
                    BannerView(url: event.imageUrl()).padding(.bottom)
                    MetaView(itemOne: MetaItem(title: "Cost", subtitle: "$100.00", image: .dollarSign),
                             itemTwo: MetaItem(title: "Date", subtitle: "Jan 15, 2023", image: .clockRoutine),
                             itemThree: MetaItem(title: "Slots Left", subtitle: "5 / 100", image: .people, size: CGSize(width: 45.0, height: 27.0)))
                    .padding(.bottom)
                    DescriptionView(desc: event.description?.text ?? "No description")
                        .padding([.leading, .trailing])
                    
                    EventDateTimeView(title: "Date & Time")
                        .padding([.leading, .trailing, .top])
                    
                    if event.isLocation(), let mapData = event.mapData() {
                        MapView(name: event.formattedTitle(), street: mapData.street, csz: mapData.csz, latitude: mapData.latitude, longitude: mapData.longitude)
                            .padding()
                        Divider().background(.gray)
                    }
                }
                .navigationTitle(event.name?.text ?? "No title")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .tabBar)
                .sheet(isPresented: $showWebView, content: {
                    WebView(url: URL(string: "https://www.eventbrite.com/e/4th-annual-pasco-county-beer-burger-festival-tickets-777916127077?aff=ehometext")!)
                })
            }
            Spacer()
            StandardButton(title: "Book Slot at Event") {
                showWebView.toggle()
            }.padding()
        }
    }
}


struct EventDateTimeView: View {
    @State var title: String = "Date & Time"
    @State private var showText: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .style(color: .white, size: .x18, weight: .w700)
                Spacer()
                Image.arrowUp
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 27)
                    .rotationEffect(.degrees(showText ? 0 : 180))
            }.padding(.bottom, 5)
            .onTapGesture {
                withAnimation {
                    showText.toggle()
                }
            }
            if showText {
                VStack(alignment: .leading, spacing: 8) {
                    buildTimeRow(key: "Start", value: "Saturday, Jan 15, 2023 - 10:00AM")
                    buildTimeRow(key: "End", value: "Saturday, Jan 15, 2023 - 4:00PM")
                }
            }
        }
    }
    
    fileprivate func buildTimeRow(key: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(key)
                .style(color: Theme.shared.placeholderGray, size: .small, weight: .w400)
                .frame(width: 60, alignment: .leading)
            Text(value)
                .style(color: .white, size: .small, weight: .w400)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}
