//
//  ScaledBezier.swift
//  Cloudy2
//
//  Created by Iain Delaney on 2022-11-02.
//  Copyright © 2022 IainDelaney. All rights reserved.
//

import Foundation
import SwiftUI

struct ScaledBezier: Shape {
    let bezierPath: UIBezierPath

    func path(in rect: CGRect) -> Path {
        let path = Path(bezierPath.cgPath)

        // Figure out how much bigger we need to make our path in order for it to fill the available space without clipping.
        let scaleX = rect.width / bezierPath.bounds.width
        let scaleY = rect.height / bezierPath.bounds.height

        // Create an affine transform that uses the multiplier for both dimensions equally.
        let transform = CGAffineTransform(scaleX: scaleX * 0.9, y: scaleY * 0.9)

        // Apply that scale and send back the result.
        return path.applying(transform)
    }
}
