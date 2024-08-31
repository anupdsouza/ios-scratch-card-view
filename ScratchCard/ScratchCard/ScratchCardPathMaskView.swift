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
    @State private var points = [CGPoint]()
    @State private var selection: Int = 0
    @State private var shine = true
    @State private var clearScratchArea = false

    private let scratchClearAmount: CGFloat = 0.5
    private let pokemon: [[String: Any]] = [
        ["name":"pikachu-3d", "color": Color.yellow],
        ["name":"squirtle-3d", "color": Color.cyan],
        ["name":"bulbasaur-3d", "color": Color.mint]
    ]
    
    var body: some View {
        VStack {
            Image("pokemon-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250)

            ZStack {
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
                    .opacity(clearScratchArea ? 0 : 1)
                    .animation(.easeInOut, value: clearScratchArea)
                    .overlay {
                        LinearGradient(colors: [.clear, .white.opacity(0.8), .clear], startPoint: .leading, endPoint: .trailing)
                            .frame(width: 100)
                            .offset(x: shine ? -250 : 250)
                            .rotationEffect(.degrees(-45))
                            .scaleEffect(2)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .animation(.linear(duration: 3.0).repeatForever(autoreverses: false), value: shine)
                    .shadow(color: .black, radius: 2)
                    .onAppear(perform: {
                        shine.toggle()
                    })

                    RoundedRectangle(cornerRadius: 20)
                        .fill(pokemon[selection]["color"] as? Color ?? .yellow)
                        .frame(width: 250, height: 250)
                        .shadow(color: .black, radius: 2)
                        .overlay {
                            Image(pokemon[selection]["name"] as? String ?? "pikachu-3d")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                        }
                        .opacity(clearScratchArea ? 1 : 0)

                    // MARK: Hidden content view
                    RoundedRectangle(cornerRadius: 20)
                        .fill(pokemon[selection]["color"] as? Color ?? .yellow)
                        .frame(width: 250, height: 250)
                        .overlay {
                            Image(pokemon[selection]["name"] as? String ?? "pikachu-3d")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
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
                                    let feedbackGen = UIImpactFeedbackGenerator(style: .light)
                                    feedbackGen.impactOccurred()
                                })
                        )
                        .opacity(clearScratchArea ? 0 : 1)
            }
            
            Button(action: {
                selection = (selection + 1) % pokemon.count
            }, label: {
                Text("Catch New !")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                    .frame(width: 220)
                    .padding(.vertical, 8)
            })
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .clipShape(Capsule())
            .padding(.vertical, 20)
        }
        .onChange(of: selection) {
            points = []
            clearScratchArea = false
        }
    }
}

#Preview {
    ScratchCardPathMaskView()
}
