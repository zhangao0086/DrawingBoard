//
//  DashLineBrush.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-16.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class DashLineBrush: BaseBrush {
   
    override func prepareForContext(context: CGContextRef) {
        let lengths: [CGFloat] = [5.0, 5.0]
        CGContextSetLineDash(context, 0, lengths, 2);
    }
    
    override func drawAtPoint(point: CGPoint, path: CGMutablePathRef) {
        CGPathMoveToPoint(path, nil, beginPoint.x, beginPoint.y)
        CGPathAddLineToPoint(path, nil, point.x, point.y)
    }
}
