//
//  TagsView.swift
//  zala
//
//  Created by Kyle Carriedo on 4/10/24.
//

import SwiftUI

struct TagGridView: View {
    
    @State var tags: [SuperUserTag]
    
    var body: some View {
        FlowLayout {
            ForEach(tags, id: \.self) { tag in
                HStack(alignment: .center) {
                    HStack(alignment: .center) {
                        Image.tag
                        Text(tag.value)
                            .style(color: .white,
                                   size: .small,
                                   weight: .w400)
                    }
                    .frame(height: 35)
                    .padding([.leading, .trailing])
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Theme.shared.mediumBlack))
                .padding(2)
            }
        }
    }
}

struct TagsView: View {
    
    var tags: [String] //only show 3
    var total: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image.tag
            ForEach(tags, id:\.self) { tag in
                HStack(alignment: .center) {
                    Text(tag)
                        .style(color: .white,
                               size: .small,
                               weight: .w400)
                    if tag != tags.last {
                        Text(",")
                            .style(color: .white,
                                   size: .small,
                                   weight: .w500)
                    } else if tag == tags.last, tags.count > 3 {
                        Text(",+\(tags.count - 3)")
                            .style(color: .white,
                                   size: .small,
                                   weight: .w400)
                    }
                }
            }
        }
    }
}



struct FlowLayout: Layout {
    
    var unspecified: ProposedViewSize = .unspecified
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(unspecified) }

        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        var lineWidth: CGFloat = 0
        var lineHeight: CGFloat = 0

        for size in sizes {
            if lineWidth + size.width > proposal.width ?? 0 {
                totalHeight += lineHeight
                lineWidth = size.width
                lineHeight = size.height
            } else {
                lineWidth += size.width
                lineHeight = max(lineHeight, size.height)
            }

            totalWidth = max(totalWidth, lineWidth)
        }

        totalHeight += lineHeight

        return .init(width: totalWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(unspecified) }

        var lineX = bounds.minX
        var lineY = bounds.minY
        var lineHeight: CGFloat = 0

        for index in subviews.indices {
            if lineX + sizes[index].width > (proposal.width ?? 0) {
                lineY += lineHeight
                lineHeight = 0
                lineX = bounds.minX
            }

            subviews[index].place(
                at: .init(
                    x: lineX + sizes[index].width / 2,
                    y: lineY + sizes[index].height / 2
                ),
                anchor: .center,
                proposal: ProposedViewSize(sizes[index])
            )

            lineHeight = max(lineHeight, sizes[index].height)
            lineX += sizes[index].width
        }
    }
}
