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
    @State var selection: Int = 0
    @State var shine = true
    let pokemon:[[String: Any]] = [
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
                    .overlay {
                        LinearGradient(colors: [.clear, .white.opacity(0.8), .clear], startPoint: .leading, endPoint: .trailing)
                            .frame(width: 100)
                            .offset(x: shine ? -250 : 250)
                            .rotationEffect(.degrees(-45))
                            .scaleEffect(2)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .animation(.linear(duration: 3.0).repeatForever(autoreverses: false), value: shine)
                    .onAppear(perform: {
                        shine.toggle()
                    })

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
                            })
                    )
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
        }
    }
}

#Preview {
    ScratchCardPathMaskView()
}
