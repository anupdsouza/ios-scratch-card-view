//
//  ScratchCardPathMaskView.swift
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

struct ScratchCardPathMaskView: View {
    @State var points = [CGPoint]()
    
    var body: some View {
        VStack {
            Image("pokemon-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250)

            ZStack {
                Image("pokemon-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)

                // MARK: Scratchable overlay view
                RoundedRectangle(cornerRadius: 20)
                    .fill(.red)
                    .frame(width: 250, height: 250)
                    .overlay {
                        Image("pokeball")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                    }

                // MARK: Hidden content view
                RoundedRectangle(cornerRadius: 20)
                    .fill(.yellow)
                    .frame(width: 250, height: 250)
                    .overlay {
                        Image("pikachu")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                    }
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
}

struct ScratchCardShapeMaskView_Previews: PreviewProvider {
    static var previews: some View {
        ScratchCardPathMaskView()
    }
}
