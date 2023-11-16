//
//  ScratchCardPathMaskView.swift
//  ScratchCard
//
//  Created by Anup D'Souza on 16/11/23.
//

import SwiftUI

struct ScratchCardPathMaskView: View {
    @State var points = [CGPoint]()
    
    var body: some View {
        ZStack {
            // MARK: Scratchable overlay view
            RoundedRectangle(cornerRadius: 20)
                .fill(.red)
                .frame(width: 250, height: 250)

            // MARK: Hidden content view
            RoundedRectangle(cornerRadius: 20)
                .fill(.yellow)
                .frame(width: 250, height: 250)
                .mask(
                    Path { path in
                        path.addLines(points)
                    }.stroke(style: StrokeStyle(lineWidth: 50, lineCap: .round, lineJoin: .round))
                )
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            points.append(value.location)
                        })
                )
        }
    }
}

struct ScratchCardShapeMaskView_Previews: PreviewProvider {
    static var previews: some View {
        ScratchCardPathMaskView()
    }
}
