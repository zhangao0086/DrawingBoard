//
//  LineBrush.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-15.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class LineBrush: BaseBrush {
    
    override func drawInContext(context: CGContextRef) {
        CGContextMoveToPoint(context, beginPoint.x, beginPoint.y)
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
    }
}
