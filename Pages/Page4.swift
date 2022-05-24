import SwiftUI

struct Page4: View {
    
    var body: some View {
        VStack {
            Text("💪 😁")
                .font(.system(size: 80))
                .padding(.bottom)
            Text("But despite how hopeless the situation may be, we can still help lift each other up even in the simplest ways!")
                .font(.system(size: 25))
                .padding(.horizontal)
                .multilineTextAlignment(.center)
        }
    }
}
