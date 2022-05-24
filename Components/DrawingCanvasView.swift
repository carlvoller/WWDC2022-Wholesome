import SwiftUI
import UIKit
import PencilKit

struct DrawingCanvasView: UIViewRepresentable {
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var canvasView: Binding<PKCanvasView>
        let onChange: (_ image: UIImage) -> Void
        private let toolPicker: PKToolPicker
        
        deinit {
            toolPicker.setVisible(false, forFirstResponder: canvasView.wrappedValue)
            toolPicker.removeObserver(canvasView.wrappedValue)
        }
        
        init(canvasView: Binding<PKCanvasView>, toolPicker: PKToolPicker, onChange: @escaping (_ image: UIImage) -> Void) {
            self.canvasView = canvasView
            self.onChange = onChange
            self.toolPicker = toolPicker
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            if canvasView.drawing.bounds.isEmpty == false {
                onChange(canvasView.drawing.image(from: canvasView.bounds, scale: 1))
            }
        }
    }
    
    @Binding var canvasView: PKCanvasView
    @Binding var toolPickerIsActive: Bool
    private let toolPicker = PKToolPicker()
    
    let onChange: (_ image: UIImage) -> Void
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.isOpaque = true
        canvasView.delegate = context.coordinator
        showToolPicker()
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if (!toolPickerIsActive) {
            toolPicker.removeObserver(uiView)
        }
        toolPicker.setVisible(toolPickerIsActive, forFirstResponder: uiView)
    }
    
    func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvasView: $canvasView, toolPicker: toolPicker, onChange: onChange)
    }
}
