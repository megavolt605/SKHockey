//
//  Tools.swift
//  SKHockey_case
//
//  Created by Igor Smirnov on 05/09/2018.
//  Copyright © 2018 Complex Numbers. All rights reserved.
//

import CoreGraphics

extension CGSize {
    var center: CGPoint {
        return CGPoint(x: width / 2.0, y: height / 2.0)
    }
}

extension Range where Bound == CGFloat {

    var random: Bound {
        return Bound(arc4random() % UInt32(upperBound - lowerBound)) + lowerBound
    }
}
