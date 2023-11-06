//
//  ContentView.swift
//  ScratchCard
//
//  Created by Anup D'Souza on 06/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {}
            .frame(width: 200, height: 300)
            .background(.yellow)
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.clear)
            }
            .overlay {
                Canvas { context, size in
                    
                }
                .frame(width: 200, height: 300)
                .border(.blue)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
