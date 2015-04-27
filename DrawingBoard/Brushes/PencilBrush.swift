//
//  PencilBrush.swift
//  DrawingBoard
//
//  Created by 张奥 on 15/3/18.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class PencilBrush: BaseBrush {
    
    override func drawInPath(inout path: CGMutablePathRef) {
        if let lastPoint = self.lastPoint {
            CGPathMoveToPoint(path, nil, lastPoint.x, lastPoint.y)
        } else {
            CGPathMoveToPoint(path, nil, beginPoint.x, beginPoint.y)
        }
        CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y)
    }
    
    override func supportedContinuousDrawing() -> Bool {
        return true
    }
}
