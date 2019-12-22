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

        // TO DO
        // перестраивать фигуры при перемене параметров филдов и по кнопке

        drawingView.wantsLayer = true
        drawingView.layer?.borderColor = .black
        drawingView.layer?.borderWidth = 0.5
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        drawingView.firstCircle = Circle(center: NSPoint(x: Double(firstCircleCenterXTextField.stringValue) ?? 0,
                                                         y: Double(firstCircleCenterYTextField.stringValue) ?? 0),
                                         radius: Double(firstCircleRadiusTextField.stringValue) ?? 0)

        drawingView.secondCircle = Circle(center: NSPoint(x: Double(secondCircleCenterXTextField.stringValue) ?? 0,
                                                          y: Double(secondCircleCenterYTextField.stringValue) ?? 0),
                                          radius: Double(secondCircleRadiusTextField.stringValue) ?? 0)

        drawingView.arcRadius = Double(arcRadiusTextField.stringValue) ?? 0
    }

    func setupTextFields() {
        firstCircleCenterXTextField.stringValue = "700"
        firstCircleCenterYTextField.stringValue = "700"
        firstCircleRadiusTextField.stringValue = "100"

        secondCircleCenterXTextField.stringValue = "350"
        secondCircleCenterYTextField.stringValue = "300"
        secondCircleRadiusTextField.stringValue = "270"

        arcRadiusTextField.stringValue = "100"
    }

    @IBAction func createArcButtonTap(_ sender: NSButton) {
        arcTitleLabel.stringValue = "Касательная дуга"
        arcCenterLabel.stringValue = "Центр дуги (X, Y)"
        touchPointsLabel.stringValue = "Точки касания:\nА (X, Y), В (X, Y)"
    }

    @IBAction func clearButtonTap(_ sender: NSButton) {
        // clear drawing field
    }
}
