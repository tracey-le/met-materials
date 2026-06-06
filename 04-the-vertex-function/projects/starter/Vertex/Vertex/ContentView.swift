///// Copyright (c) 2025 Kodeco Inc.

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      MetalView()
        .border(Color.pink, width: 2)
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
