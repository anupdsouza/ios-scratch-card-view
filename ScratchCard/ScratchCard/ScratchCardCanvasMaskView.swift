//
//  ScratchCardView.swift
//  ScratchCard
//
//  Created by Anup D'Souza on 16/11/23.
//  🕸️ https://www.anupdsouza.com
//  🔗 https://twitter.com/swift_odyssey
//  👨🏻‍💻 https://github.com/anupdsouza
//  ☕️ https://www.buymeacoffee.com/adsouza
//  🫶🏼 https://patreon.com/adsouza
//

import SwiftUI

struct Line {
    var points = [CGPoint]()
    var lineWidth: Double = 50.0
}

struct ScratchCardCanvasMaskView: View {
    @State private var currentLine = Line()
    @State private var lines = [Line]()
    
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
                    Canvas { context, _ in
                        for line in lines {
                            var path = Path()
                            path.addLines(line.points)
                            context.stroke(path,
                                           with: .color(.white),
                                           style: StrokeStyle(lineWidth: line.lineWidth,
                                                              lineCap: .round,
                                                              lineJoin: .round)
                            )
                        }
                    }
                )
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            let newPoint = value.location
                            currentLine.points.append(newPoint)
                            lines.append(currentLine)
                        })
                )
        }
    }
}

#Preview {
    ScratchCardCanvasMaskView()
}
