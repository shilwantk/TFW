//
//  MarketPlaceStoreView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI

struct StoreUrl: Identifiable {
    var id: UUID = UUID()
    var url: String
}

struct MarketPlaceStoreView: View {
    
    let data = (1...100).map { "Item \($0)" }
        
    @State var service: SquareService = SquareService()
    @State var url: StoreUrl? = nil
    
    let columns = [
        GridItem(.adaptive(minimum: 172))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Array(service.storeItems), id: \.self) { item in
                    StoreCellView(name: item.itemData?.name ?? "-", 
                                  imgUrl: service.imgFor(item),
                                  price: item.formattedPrice())
                    .onTapGesture {
                        if let product = item.itemData?.variations?.last?.url() {
                            url = .init(url: product)
                        }
                        
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            service.fetchStoreItems()
        }
        .sheet(item: $url, onDismiss: {
            url = nil
        }, content: { product in
            SafariWebView(url: URL(string: product.url)!)
                .ignoresSafeArea()
        })
    }
}

#Preview {
    MarketPlaceStoreView()
}
