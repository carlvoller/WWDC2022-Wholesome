import SwiftUI
import AVFoundation

struct Page7: View {
    
    @State var personCount: Int = 0
    @State var points: Int = 0
    @Binding var compliments: [String]
    
    let emojis = ["💕", "🥰", "❤️", "😍"]
    
    func tts(text: String) {
        points += personCount * 10
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            CameraView(personCount: $personCount)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            VStack {
                Text("Find someone near you, walk up to them and tap on a compliment!")
                    .font(.system(size: 30))
                Text("People in frame: \(personCount)")
                    .font(.system(size: 20))
            }
            .padding()
            .padding(.horizontal)
            .background(Color.blue)
            .cornerRadius(10)
            .frame(alignment: .top)
            .padding(.top, 20)
            
            ZStack(alignment: .bottomLeading) {
                VStack {
                    Text("Compliments")
                        .font(.system(size: 25))
                    Text("Make sure your iPad is not on silent mode!")
                        .font(.system(size: 16))
                    List {
                        ForEach(compliments, id: \.self) { compliment in
                            Button(action: {
                                tts(text: compliment)
                            }) {
                                HStack {
                                    Text(emojis.randomElement() ?? "")
                                        .font(.system(size: 40))
                                        .padding()
                                    Text(compliment)
                                        .padding(10)
                                        .font(.system(size: 30))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .cornerRadius(10)
                                }
                            }
                            
                            
                        }
                    }
                    .listStyle(.plain)
                    .frame(maxWidth: 350, maxHeight: 300, alignment: .top)
                    .padding(.top)
                }
                .padding(.horizontal, 35)
                .padding(.vertical, 25)
                .background(Color.black)
                .cornerRadius(15)
                .frame(alignment: .bottom)
            }
            .padding(.leading, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    Text("Score")
                        .font(.system(size: 25))
                        .padding(.horizontal)
                    Text("\(points)")
                        .font(.system(size: 50))
                        .padding(.horizontal)
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.black)
                .cornerRadius(10)
                .opacity(0.5)
                .padding(.trailing, 50)
                .padding(.bottom, 50)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
            
            
    }
}
