import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var drawingView: Drawing!

    @IBOutlet weak var firstCircleCenterXTextField: NSTextField!
    @IBOutlet weak var firstCircleCenterYTextField: NSTextField!
    @IBOutlet weak var firstCircleRadiusTextField: NSTextField!
    @IBOutlet weak var secondCircleCenterXTextField: NSTextField!
    @IBOutlet weak var secondCircleCenterYTextField: NSTextField!
    @IBOutlet weak var secondCircleRadiusTextField: NSTextField!
    @IBOutlet weak var arcRadiusTextField: NSTextField!

    @IBOutlet weak var createArcButton: NSButton!
    @IBOutlet weak var arcTitleLabel: NSTextFieldCell!
    @IBOutlet weak var arcCenterLabel: NSTextField!
    @IBOutlet weak var touchPointsLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = .white

        setupTextFields()

        drawingView.wantsLayer = true
        drawingView.layer?.borderColor = .black
        drawingView.layer?.borderWidth = 0.5
        drawingView.delegate = self
    }

    func setupTextFields() {
        firstCircleCenterXTextField.stringValue = "970"
        firstCircleCenterYTextField.stringValue = "500"
        firstCircleRadiusTextField.stringValue = "250"

        secondCircleCenterXTextField.stringValue = "350"
        secondCircleCenterYTextField.stringValue = "300"
        secondCircleRadiusTextField.stringValue = "150"

        arcRadiusTextField.stringValue = "300"
    }

    @IBAction func createArcButtonTap(_ sender: NSButton) {
        drawingView.firstCircle = Circle(center: NSPoint(x: Double(firstCircleCenterXTextField.stringValue) ?? 0,
                                                         y: Double(firstCircleCenterYTextField.stringValue) ?? 0),
                                         radius: Double(firstCircleRadiusTextField.stringValue) ?? 0)

        drawingView.secondCircle = Circle(center: NSPoint(x: Double(secondCircleCenterXTextField.stringValue) ?? 0,
                                                          y: Double(secondCircleCenterYTextField.stringValue) ?? 0),
                                          radius: Double(secondCircleRadiusTextField.stringValue) ?? 0)

        drawingView.arcRadius = Double(arcRadiusTextField.stringValue) ?? 0

        drawingView.isDrawing = true
        drawingView.setNeedsDisplay(drawingView.bounds)
    }

    @IBAction func clearButtonTap(_ sender: NSButton) {
        drawingView.isDrawing = false
        drawingView.setNeedsDisplay(drawingView.bounds)
        arcTitleLabel.stringValue = ""
        arcCenterLabel.stringValue = ""
        touchPointsLabel.stringValue = ""
    }
}

extension ViewController: Calculatable {
    func didCalculate(center: NSPoint, pointA: NSPoint, pointB: NSPoint) {
        arcTitleLabel.stringValue = "Касательная дуга"
        arcCenterLabel.stringValue = "Центр:\n(\(Int(center.x.rounded())), \(Int(center.y.rounded())))"
        touchPointsLabel.stringValue =
        "Точки касания:\nА (\(Int(pointA.x.rounded())), \(Int(pointA.y.rounded())))\nВ (\(Int(pointB.x.rounded())), \(Int(pointB.y.rounded())))"
    }
}
