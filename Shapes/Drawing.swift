import Cocoa

class Drawing: NSView {
    var firstCircle: Circle?
    var secondCircle: Circle?
    var arcRadius: Double?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let firstCircle = firstCircle, let secondCircle = secondCircle else {
            return
        }

        draw(firstCircle, strokeColor: .black, lineWidth: 2)
        draw(secondCircle, strokeColor: .black, lineWidth: 2)

        drawAssistantCircles(touchType: .outer)
        draw(findAssistantCirclesIntersection(), strokeColor: .brown)
    }

    func draw(_ point: NSPoint, strokeColor: NSColor) {
        let rect = NSRect(x: Double(point.x) - 2,
                          y: Double(point.y) - 2,
                          width: 4,
                          height: 4)
        let path = NSBezierPath(ovalIn: rect)
        strokeColor.setStroke()
        path.lineWidth = 4
        path.stroke()
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

        draw(Circle(center: firstCircle.center, radius: firstRadius), strokeColor: .red, lineWidth: 1)
        draw(Circle(center: secondCircle.center, radius: secondRadius), strokeColor: .red, lineWidth: 1)
    }

    func findAssistantCirclesIntersection() -> NSPoint {
        guard let firstCircle = firstCircle, let secondCircle = secondCircle, let arcRadius = arcRadius else {
            return .zero
        }

        let distanceBetweenCenters = Double(sqrt(pow(abs(secondCircle.center.x - firstCircle.center.x), 2) +
                                                 pow(abs(secondCircle.center.y - firstCircle.center.y), 2)))
        let r1 = firstCircle.radius + arcRadius
        let r2 = secondCircle.radius + arcRadius
        let a = (pow(r1, 2) - pow(r2, 2) + pow(distanceBetweenCenters, 2)) / (2 * distanceBetweenCenters)
        let h = sqrt(abs(pow(r1, 2) - pow(a, 2)))

        let p3 = findP3(a: a, d: distanceBetweenCenters)

        return findArcCenter(h: h, d: distanceBetweenCenters, p3: p3)
    }

    func findP3(a: Double, d: Double) -> NSPoint {
        guard let firstCircle = firstCircle, let secondCircle = secondCircle else {
            return .zero
        }

        let p3x = Double(firstCircle.center.x) + (a / d) * Double(secondCircle.center.x - firstCircle.center.x)
        let p3y = Double(firstCircle.center.y) + (a / d) * Double(secondCircle.center.y - firstCircle.center.y)

        return NSPoint(x: p3x, y: p3y)
    }

    func findArcCenter(h: Double, d: Double, p3: NSPoint) -> NSPoint {
        guard let firstCircle = firstCircle, let secondCircle = secondCircle else {
            return .zero
        }

        let p4x = Double(p3.x) + (h / d) * Double(secondCircle.center.y - firstCircle.center.y)
        let p4y = Double(p3.y) - (h / d) * Double(secondCircle.center.x - firstCircle.center.x)

        return NSPoint(x: p4x, y: p4y)
    }

    func drawArc() {
        
    }
}
