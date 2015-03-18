//
//  EllipseBrush.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-16.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class EllipseBrush: BaseBrush {
   
    override func drawAtPoint(point: CGPoint, path: CGMutablePathRef) {
        CGPathAddEllipseInRect(path, nil, CGRect(origin: CGPoint(x: min(beginPoint.x, point.x), y: min(beginPoint.y, point.y)),
            size: CGSize(width: abs(point.x - beginPoint.x), height: abs(point.y - beginPoint.y))))
    }
}
