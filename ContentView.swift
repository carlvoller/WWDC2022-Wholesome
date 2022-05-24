import SwiftUI

struct ContentView: View {
    
    @State var page = 0
    @State var compliments: [String] = []
    
    var body: some View {
        ZStack {
            Color.black
            ZStack {
                
                switch page {
                case 0:
                    //Page5(compliments: $compliments)
                    Page1()
                        .frame(maxWidth: 800, alignment: .center)
                case 1:
                    Page2()
                        .frame(maxWidth: 800, alignment: .center)
                case 2:
                    Page3()
                        .frame(maxWidth: 800, alignment: .center)
                case 3:
                    Page4()
                        .frame(maxWidth: 800, alignment: .center)
                case 4:
                    Page5(compliments: $compliments, page: $page)
                case 5:
                    Page6()
                        .frame(maxWidth: 800, alignment: .center)
                case 6:
                    Page7(compliments: $compliments)
                default:
                    Text("Invalid Page Number")
                }
                if (page < 4 || page == 5) {
                    HStack {
                        if page > 0 {
                            Button(action: {
                                withAnimation {
                                    page -= 1
                                }
                            }) {
                                Image(systemName: "arrow.left")
                                Text("Back")
                            }
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.red)
                            .cornerRadius(10)
                            .padding(.horizontal, 10)
                            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                        }
                        
                        Button(action: {
                            withAnimation {
                                page += 1
                            }
                        }) {
                            Text("Next")
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(Color.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                    }
                    .padding(.vertical, 40)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
                
            }
            .preferredColorScheme(.dark)
        }
    }
}
