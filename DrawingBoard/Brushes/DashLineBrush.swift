//
//  DashLineBrush.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-16.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class DashLineBrush: BaseBrush {
    
    override func drawInPath(inout path: CGMutablePathRef) {
        CGPathMoveToPoint(path, nil, beginPoint.x, beginPoint.y)
        CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y)
        
        let lengths: [CGFloat] = [self.strokeWidth * 3, self.strokeWidth * 3]
        let dashLinePath = CGPathCreateCopyByDashingPath(path, nil, 0, lengths, 2)
        path = CGPathCreateMutableCopy(dashLinePath)
    }
}
