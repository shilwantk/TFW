//
//  BookTimeCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct BookTimeCellView: View {
    
    @State var viewOnly: Bool = false
    @State var showTotal: Bool = false
    @State var bookDate: Date = Date()
    @State var total: [Date] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing:5, content: {
            HStack {
                VStack(alignment: .leading, spacing:5, content: {
                    Text(DateFormatter.weekdayMonthDay(date: bookDate))
                        .style(size: .regular, weight: .w700)
                    if showTotal {
                        Text("(\(total.count)) Available")
                            .style(color: Theme.shared.lightBlue, size: .regular, weight: .w400)
                    } else {
                        Text(DateFormatter.timeOnly(date: bookDate))
                            .style(color: Theme.shared.lightBlue, size: .regular, weight: .w400)
                    }
                })
                Spacer()
                if !viewOnly {
                    Image.arrowRight
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack)
            )
        })
    }
}

#Preview {
    BookTimeCellView()
}
