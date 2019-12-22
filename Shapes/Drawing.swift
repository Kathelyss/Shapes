import Cocoa

class Drawing: NSView {
    var firstCircle: Circle?
    var secondCircle: Circle?
    var arcRadius: Double?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let firstCircle = firstCircle, let secondCircle = secondCircle, let arcRadius = arcRadius else {
            return
        }

        draw(firstCircle, strokeColor: .black, lineWidth: 2)
        draw(secondCircle, strokeColor: .black, lineWidth: 2)

        drawAssistantCircles(touchType: .outer)
    }

    func draw(_ circle: Circle, strokeColor: NSColor, lineWidth: CGFloat) {
        let rect = NSRect(x: Double(circle.center.x) - circle.radius,
                          y: Double(circle.center.y) - circle.radius,
                          width: circle.radius * 2,
                          height: circle.radius * 2)
        let circlePath = NSBezierPath(ovalIn: rect)
        strokeColor.setStroke()
        circlePath.lineWidth = lineWidth
        circlePath.stroke()
    }

    func drawAssistantCircles(touchType: TouchType) {
        guard let firstCircle = firstCircle, let secondCircle = secondCircle, let arcRadius = arcRadius else {
            return
        }

        let firstRadius: Double
        let secondRadius: Double

        switch touchType {
        case .outer:
            firstRadius = arcRadius + firstCircle.radius
            secondRadius = arcRadius + secondCircle.radius

        case .inner:
            firstRadius = arcRadius - firstCircle.radius
            secondRadius = arcRadius - secondCircle.radius

        case .complex:
            firstRadius = arcRadius + firstCircle.radius
            secondRadius = arcRadius - secondCircle.radius
        }

        print("r1: \(firstRadius), r2: \(secondRadius)")
        draw(Circle(center: firstCircle.center, radius: firstRadius), strokeColor: .red, lineWidth: 1)
        draw(Circle(center: secondCircle.center, radius: secondRadius), strokeColor: .red, lineWidth: 1)
    }

    func countDistance() {
        
    }
}
