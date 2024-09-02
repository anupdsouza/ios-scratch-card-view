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
    @State private var topViewShouldShine = false
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
                    .shimmer(shine: $topViewShine, stopShine: $topViewShouldShine)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .compositingGroup()
                    .shadow(color: .black, radius: 2)
                    .opacity(clearScratchArea ? 0 : 1)
                    .id(topViewShouldShine)
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
                                    if !topViewShouldShine {
                                        topViewShouldShine.toggle()
                                        topViewShine.toggle()
                                    }
                                })
                                .onEnded({ _ in
                                    // Create the CGPath from the drawn points
                                    let cgpath = Path { path in
                                        path.addLines(points)
                                    }.cgPath
                                    
                                    // Create a stroked version of the path to represent the thickness of the scratch
                                    let contourPath = cgpath.copy(strokingWithWidth: 50, lineCap: .round, lineJoin: .round, miterLimit: 10)
                                    
                                    // Define the bounding box of the scratchable area
                                    let boundingRect = CGRect(x: 0, y: 0, width: 250, height: 250)
                                    
                                    // Create a bitmap context to count the number of pixels covered by the path
                                    let context = CGContext(data: nil, width: Int(boundingRect.width), height: Int(boundingRect.height), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
                                    
                                    // Set the fill color (white) to the context
                                    context.setFillColor(UIColor.white.cgColor)
                                    
                                    // Add the stroked path to the context
                                    context.addPath(contourPath)
                                    
                                    // Fill the path in the context
                                    context.fillPath()
                                    
                                    // Get the pixel data from the context
                                    let pixelData = context.data!
                                    let data = pixelData.bindMemory(to: UInt8.self, capacity: Int(boundingRect.width * boundingRect.height))
                                    
                                    // Count the number of pixels that are filled (non-zero)
                                    var filledPixels = 0
                                    for i in 0..<Int(boundingRect.width * boundingRect.height) {
                                        if data[i] > 0 {
                                            filledPixels += 1
                                        }
                                    }
                                    
                                    // Calculate the percentage of the area that is scratched
                                    let totalPixels = Int(boundingRect.width * boundingRect.height)
                                    let percentage = Double(filledPixels) / Double(totalPixels)
                                    
                                    // Check if the percentage exceeds the threshold
                                    if percentage > scratchClearAmount {
                                        clearScratchArea = true
                                        // TODO: Start motion updates after a delay
                                    }
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
        .onChange(of: selection, perform: { value in
            points = []
            clearScratchArea = false
            topViewShouldShine.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                topViewShine.toggle()
            }
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
    @Binding var stopShine: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(colors: [.clear, .white.opacity(0.8), .clear], startPoint: .leading, endPoint: .trailing)
                    .frame(width: 100)
                    .offset(x: shine ? -250 : 250)
                    .rotationEffect(.degrees(-45))
                    .scaleEffect(2)
                    .animation(stopShine ? .none :
                        repeatCount != nil ?
                            .linear(duration: duration).repeatCount(repeatCount!, autoreverses: false) :
                                .linear(duration: duration).repeatForever(autoreverses: false),
                        value: stopShine ? false : shine
                    )
            )
    }
}

extension View {
    func shimmer(repeatCount: Int? = nil, duration: Double = 3.0, shine: Binding<Bool>, stopShine: Binding<Bool>) -> some View {
        self.modifier(ShimmerModifier(repeatCount: repeatCount, duration: duration, shine: shine, stopShine: stopShine))
    }
}
