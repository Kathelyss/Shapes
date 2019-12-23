import Cocoa

protocol Calculatable: AnyObject {
    func didCalculate(center: NSPoint, pointA: NSPoint, pointB: NSPoint)
}

class Drawing: NSView {
    var firstCircle: Circle?
    var secondCircle: Circle?
    var arcRadius: Double?

    var isDrawing: Bool = false
    weak var delegate: Calculatable?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard isDrawing else { return }
        
        guard let firstCircle = firstCircle, let secondCircle = secondCircle, let arcRadius = arcRadius else {
            return
        }

        draw(firstCircle, strokeColor: .black, lineWidth: 2)
        draw(secondCircle, strokeColor: .black, lineWidth: 2)

        do {
            let arcCenter = try findAssistantCirclesIntersection()
            drawAssistantCircles(touchType: .outer)


            let thirdCircle = Circle(center: arcCenter, radius: arcRadius)
            let arcStartPoint = findTouchPoint(circle1: firstCircle, circle2: thirdCircle)
            let arcEndPoint = findTouchPoint(circle1: secondCircle, circle2: thirdCircle)

            [firstCircle.center, secondCircle.center, arcCenter, arcStartPoint, arcEndPoint].forEach {
                draw($0, strokeColor: NSColor.systemGreen.withAlphaComponent(0.3))
            }

            drawArc(start: arcStartPoint,
                    end: arcEndPoint,
                    center: arcCenter,
                    radius: arcRadius,
                    strokeColor: .systemGreen)

            delegate?.didCalculate(center: arcCenter, pointA: arcStartPoint, pointB: arcEndPoint)
        } catch {
            print("Error: \(error)")
        }
    }

    func draw(_ point: NSPoint, strokeColor: NSColor) {
        let rect = NSRect(x: Double(point.x) - 1, y: Double(point.y) - 1, width: 2, height: 2)
        let path = NSBezierPath(ovalIn: rect)
        strokeColor.setStroke()
        path.lineWidth = 2
        path.stroke()
    }

    func drawArc(start: NSPoint, end: NSPoint, center: NSPoint, radius: Double, strokeColor: NSColor) {
        let path = NSBezierPath()
        let startAngle = atan2(start.y - center.y, start.x - center.x) * 180 / .pi
        let endAnle = atan2(end.y - center.y, end.x - center.x) * 180 / .pi
        path.appendArc(withCenter: center, radius: CGFloat(radius), startAngle: startAngle, endAngle: endAnle, clockwise: true)
        strokeColor.setStroke()
        path.lineWidth = 2
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
            firstRadius = abs(arcRadius - firstCircle.radius)
            secondRadius = abs(arcRadius - secondCircle.radius)
        }

        draw(Circle(center: firstCircle.center, radius: firstRadius), strokeColor: .systemGreen, lineWidth: 0.1)
        draw(Circle(center: secondCircle.center, radius: secondRadius), strokeColor: .systemGreen, lineWidth: 0.1)
    }

    // MARK: - Calculations

    func findAssistantCirclesIntersection() throws -> NSPoint {
        guard let firstCircle = firstCircle, let secondCircle = secondCircle, let arcRadius = arcRadius else {
            return .zero
        }

        let distanceBetweenCenters = Double(sqrt(pow(abs(secondCircle.center.x - firstCircle.center.x), 2) +
                                                 pow(abs(secondCircle.center.y - firstCircle.center.y), 2)))

        guard distanceBetweenCenters > 0 else {
            throw DrawingError.arcError
        }

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

        return NSPoint(x: Double(firstCircle.center.x) + (a / d) * Double(secondCircle.center.x - firstCircle.center.x),
                       y: Double(firstCircle.center.y) + (a / d) * Double(secondCircle.center.y - firstCircle.center.y))
    }

    func findArcCenter(h: Double, d: Double, p3: NSPoint) -> NSPoint {
        guard let firstCircle = firstCircle, let secondCircle = secondCircle else {
            return .zero
        }

        return NSPoint(x: Double(p3.x) + (h / d) * Double(secondCircle.center.y - firstCircle.center.y),
                       y: Double(p3.y) - (h / d) * Double(secondCircle.center.x - firstCircle.center.x))
    }

    func findTouchPoint(circle1: Circle, circle2: Circle) -> NSPoint {
        let diffX = Double(circle2.center.x - circle1.center.x)
        let diffY = Double(circle2.center.y - circle1.center.y)
        let coeff = circle1.radius / (circle1.radius + circle2.radius)
        let pX = Double(circle1.center.x) + diffX * coeff
        let pY = Double(circle1.center.y) + diffY * coeff
        return NSPoint(x: pX, y: pY)
    }
}
