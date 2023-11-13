//
//  ResizableTagGroup.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 09/11/23.
//

import SwiftUI

struct ChipsStack: Layout {
    private let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        let maxViewHeight = sizes.map { $0.height }.max() ?? 0
        var currentRowWidth: CGFloat = 0
        var totalHeight: CGFloat = maxViewHeight
        var totalWidth: CGFloat = 0
        
        for size in sizes {
            if currentRowWidth + spacing + size.width > proposal.width ?? 0 {
                totalHeight += spacing + maxViewHeight
                currentRowWidth = size.width
            } else {
                currentRowWidth += spacing + size.width
            }
            totalWidth = max(totalWidth, currentRowWidth)
        }
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        let maxViewHeight = sizes.map { $0.height }.max() ?? 0
        var point = CGPoint(x: bounds.minX, y: bounds.minY)
        for index in subviews.indices {
            if point.x + sizes[index].width > bounds.maxX {
                point.x = bounds.minX
                point.y += maxViewHeight + spacing
            }
            subviews[index].place(at: point, proposal: ProposedViewSize(sizes[index]))
            point.x += sizes[index].width + spacing
        }
    }
}

struct ResizableTagGroup<Content: View>: View {
    
    let visualContent: [Content]
    
    var body: some View {
        ChipsStack {
            ForEach(0..<visualContent.count, id: \.self){ index in
                visualContent[index]
            }
             
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ResizableTagGroup(visualContent: [Text("Algo")])
}
