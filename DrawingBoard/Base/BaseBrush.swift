//
//  BaseBrush.swift
//  DrawingBoard
//
//  Created by 张奥 on 15/3/18.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import CoreGraphics

protocol PaintBrush {
    
    func supportedContinuousDrawing() -> Bool
    
    func drawInPath(inout path: CGMutablePathRef)
}

class BaseBrush : NSObject, PaintBrush {
    var beginPoint: CGPoint!
    var endPoint: CGPoint!
    var lastPoint: CGPoint?
    weak var context: CGContextRef?
    
    var strokeWidth: CGFloat!
    
    func supportedContinuousDrawing() -> Bool {
        return false
    }
    
    func drawInPath(inout path: CGMutablePathRef) {
        assert(false, "must implements in subclass.")
    }
}