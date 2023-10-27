//
//  TabShape.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import SwiftUI

struct TabShape: Shape {
    // MARK: - Properties

    var midPoint: CGFloat

    var animatableData: CGFloat {
        get { midPoint }
        set {
            midPoint = newValue
        }
    }

    // MARK: - Functions

    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addPath(Rectangle().path(in: rect))

            path.move(to: .init(x: midPoint - 60, y: 0))

            let to = CGPoint(x: midPoint, y: -25)
            let control1 = CGPoint(x: midPoint - 25, y: 0)
            let control2 = CGPoint(x: midPoint - 25, y: -25)

            path.addCurve(to: to, control1: control1, control2: control2)

            let to1 = CGPoint(x: midPoint + 60, y: 0)
            let control3 = CGPoint(x: midPoint + 25, y: -25)
            let control4 = CGPoint(x: midPoint + 25, y: 0)

            path.addCurve(to: to1, control1: control3, control2: control4)
        }
    }
}
