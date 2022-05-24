import SwiftUI

struct Page2: View {
    
    var body: some View {
        
            VStack {
                Image(systemName: "globe")
                    .padding(.bottom)
                    .font(.system(size: 50))
                    .foregroundColor(Color.cyan)
                Text("According to the World Health Organisation, in 2021 over 280 MILLION people in the world suffer from depression.")
                    .font(.system(size: 25))
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }
    }
}
