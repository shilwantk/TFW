//
//  AttachmentImageView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/23/24.
//

import SwiftUI

struct AttachmentImageView: View {
    @State var image: Image = Image("attach-demo")
    @State var attachment: AttachmentItem
    @State var stacked: Bool = false
    var onComplete: ((_ item: AttachmentItem) -> Void)?
    var body: some View {
        if stacked {
            ZStack(alignment: .center) {
                Image("attach-demo")
                Image("attach-demo")
                    .padding(.leading, 55)
                    .padding(.top, 55)
                    .rotationEffect(.degrees(350))
            }
        } else {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: attachment.uiImage)
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140, alignment: .center)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                Button {
                    onComplete?(attachment)
                } label: {
                    Image.closeMini
                }
            }
        }
    }
}
