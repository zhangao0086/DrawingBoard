//
//  LinePainter.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-15.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class LinePainter: BasePainter {
    
    override func drawAtPoint(point: CGPoint, path: CGMutablePathRef) {       
        CGPathMoveToPoint(path, nil, beginPoint.x, beginPoint.y)
        CGPathAddLineToPoint(path, nil, point.x, point.y)
    }
}
