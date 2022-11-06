//
//  PointGenerator.swift
//  StarWars
//
//  Created by Aleksey Rochev (Netology) on 19.11.2019.
//  Copyright © 2019 Aleksey Rochev (Netology). All rights reserved.
//

import UIKit

//struct Point: Equatable {
//    var x: Int
//    var y: Int
//
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        return lhs.x == rhs.x && lhs.y == rhs.y
//    }
//}

typealias Point = CGPoint   // A structure that contains a point in a two-dimensional coordinate system.
typealias Rect = CGRect     // A structure that contains the location and dimensions of a rectangle.

extension Point {
//    private let spaceSize: Int = 10
    static func generate() -> Point {
        let x = Int.random(in: 0...10) // 11x11 это получаются размеры космоса :)
        let y = Int.random(in: 0...10)
        return Point(x: x, y: y)
    }
}

extension Rect {
    static func generate() -> Rect {
        let w = Int.random(in: 2...4)
        let h = Int.random(in: 2...4)
        let x = Int.random(in: 0...10 - w + 1)
        let y = Int.random(in: 0...10 - h + 1)
        return Rect(x: x, y: y, width: w, height: h) // некоторые квадратики могли выйти за границу космоса. Крайняя точка + размеры.
    }
}
