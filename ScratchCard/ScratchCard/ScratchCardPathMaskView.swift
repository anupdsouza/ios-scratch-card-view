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
    @State private var topViewShine = true
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
                // MARK: Scratchable TOP view
                RoundedRectangle(cornerRadius: 20)
                    .fill(.red)
                    .frame(width: 250, height: 250)
                    .overlay {
                        Image("pokeball")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                    }
                    .animation(.easeInOut, value: clearScratchArea)
                    .shimmer(shine: $topViewShine)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .compositingGroup()
                    .shadow(color: .black, radius: 2)
                    .opacity(clearScratchArea ? 0 : 1)
                    .onAppear(perform: {
                        topViewShine.toggle()
                    })

                    RoundedRectangle(cornerRadius: 20)
                        .fill(pokemon[selection]["color"] as? Color ?? .yellow)
                        .frame(width: 250, height: 250)
                        .overlay {
                            Image(pokemon[selection]["name"] as? String ?? "pikachu-3d")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                        }
                        .compositingGroup()
                        .shadow(color: .black, radius: 2)
                        .opacity(clearScratchArea ? 1 : 0)

                    // MARK: Hidden REVEAL view
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
        .onChange(of: selection, perform: { value in
            points = []
            clearScratchArea = false
        })
    }
}

#Preview {
    ScratchCardPathMaskView()
}

struct ShimmerModifier: ViewModifier {
    var repeatCount: Int? = nil
    var duration: Double
    
    @Binding var shine: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(colors: [.clear, .white.opacity(0.8), .clear], startPoint: .leading, endPoint: .trailing)
                    .frame(width: 100)
                    .offset(x: shine ? -250 : 250)
                    .rotationEffect(.degrees(-45))
                    .scaleEffect(2)
                    .animation(
                        repeatCount != nil ?
                            .linear(duration: duration).repeatCount(repeatCount!, autoreverses: false) :
                                .linear(duration: duration).repeatForever(autoreverses: false),
                        value: shine
                    )
            )
    }
}

extension View {
    func shimmer(repeatCount: Int? = nil, duration: Double = 3.0, shine: Binding<Bool>) -> some View {
        self.modifier(ShimmerModifier(repeatCount: repeatCount, duration: duration, shine: shine))
    }
}
