//
//  EllipseBrush.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-16.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class EllipseBrush: BaseBrush {
   
    override func drawInContext(context: CGContextRef) {
        CGContextAddEllipseInRect(context, CGRect(origin: CGPoint(x: min(beginPoint.x, endPoint.x), y: min(beginPoint.y, endPoint.y)),
            size: CGSize(width: abs(endPoint.x - beginPoint.x), height: abs(endPoint.y - beginPoint.y))))
    }
}
