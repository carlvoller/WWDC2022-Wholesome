import SwiftUI
import NaturalLanguage
import Vision
import PencilKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Page5: View {
    
    @State var currentCompliment: String = "";
    @Binding var compliments: [String];
    @Binding var page: Int;
    @State var currentSentiment: Double = 0;
    @State var image: UIImage?;
    @State var detectedText = "";
    @State var canvasView = PKCanvasView()
    @State var isToolPickerActive = true;
    
    let emojis = ["💕", "🥰", "❤️", "😍"]
    
    func processSentiment(text: String) {
        
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let sentiment = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore).0
        currentSentiment = Double(sentiment?.rawValue ?? "0") ?? 0;
    }
    
    func submit() {
        print(currentSentiment)
        if currentSentiment > 0.25 {
            compliments.append(currentCompliment)
            currentCompliment = ""
            currentSentiment = 0
            canvasView.drawing = PKDrawing()
        }
    }
    
    var body: some View {
        
        HStack {
            VStack {
                Text("Let's start by writing a series of compliments to use. ❤️")
                    .font(.system(size: 25))
                    .padding(.horizontal)
                Text("Use your Apple Pencil to write down notes of encouragement/compliments just like making a nice little love or thank you note 📝\n\nAlternatively, just type out your compliment in the textbox above the drawing area. ⌨️\n\nWe use Natural Language Processing to ensure your messages contain good vibes and good vibes only! 😁")
                    .font(.system(size: 17))
                    .padding()
                    .listRowBackground(Color.clear)
                
                Text("Your compliments will appear here:")
                    .padding(.top, 40)
                
                List {
                    ForEach(compliments, id: \.self) { compliment in
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
                        .listRowBackground(Color.clear)
                        
                    }
                }
                .listStyle(.plain)
                .frame(maxWidth: .infinity, maxHeight: 300, alignment: .top)
                .padding(.top)
                
                if compliments.count > 2 {
                    Button(action: {
                        isToolPickerActive = false
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
            }
            .padding()
            .frame(maxWidth: 400, maxHeight: .infinity, alignment: .leading)
            .background(Color(red: 21/255, green: 21/255, blue: 21/255))
            
            VStack {
                HStack {
                    Text("Detected Text:")
                    TextField("Your compliment will appear here...", text: $currentCompliment)
                    Button(action: {
                        currentCompliment = ""
                        currentSentiment = 0
                        canvasView.drawing = PKDrawing()
                    }) {
                        Image(systemName: "goforward")
                    }
                    .padding(10)
                    .foregroundColor(Color.white)
                    .background(Color.gray)
                    .cornerRadius(15)
                    
                    Text(currentCompliment == "" ? "Write a compliment!"
                         : currentSentiment > 0.25 ? "Wholesome!"
                         : currentSentiment > 0 ? "Good, but can be better!"
                         : currentSentiment > -0.25 ? "Try harder!" : "That's too mean!")
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(currentCompliment == "" ? Color.gray
                                    : currentSentiment > 0.25 ? Color.green
                                    : currentSentiment > -0.25 ? Color.yellow : Color.red)
                        .cornerRadius(15)
                    if currentSentiment > 0.25 {
                        Button(action: submit) {
                            Text("Add")
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 40)
                DrawingCanvasView(canvasView: $canvasView, toolPickerIsActive: $isToolPickerActive, onChange: { image in
                    self.image = image
                })
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 4)
                    )
                    .padding()
                    .onChange(of: image, perform: { newImage in
                        
                        guard let image = image?.cgImage else { return }
                        
                        let requestHandler = VNImageRequestHandler(cgImage: image)
                        
                        func recogniseTextHandler(request: VNRequest, error: Error?) {
                            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                            
                            let text = observations.compactMap { o in
                                return o.topCandidates(1).first?.string
                            }
                                .joined()
                            
                            print(text)
                            currentCompliment = text
                        }
                        
                        let request = VNRecognizeTextRequest(completionHandler: recogniseTextHandler)
                        request.recognitionLanguages = ["en-US"]
                        
                        do {
                            try requestHandler.perform([request]);
                        } catch {
                            print("Unable to perform the requests: \(error).")
                        }
                        
                    })
                    .onChange(of: currentCompliment, perform: { newC in
                        processSentiment(text: currentCompliment)
                    })
            }
            .padding(.vertical, 100)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        
    }
}

