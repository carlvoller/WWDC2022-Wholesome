import SwiftUI

struct Page6: View {
    
    var body: some View {
        VStack {
            Text("👫 👀")
                .font(.system(size: 80))
                .padding(.bottom)
            Text("Now that you've come up with some wholesome compliments, it's time find someone to share them with!")
                .font(.system(size: 25))
                .padding(.horizontal)
                .multilineTextAlignment(.center)
        }
    }
}
