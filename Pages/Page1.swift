import SwiftUI

struct Page1: View {
    
    var body: some View {
        VStack {
                Text("😞")
                    .font(.system(size: 80))
                    .padding(.bottom)
                Text("Mental Health is a serious issue\n in this day and age")
                    .font(.system(size: 25))
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
        }
    }
}
