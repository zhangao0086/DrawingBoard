//
//  BaseBrush.swift
//  DrawingBoard
//
//  Created by 张奥 on 15/3/18.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import CoreGraphics

protocol PaintBrush {
    
    func supportedContinuousDrawing() -> Bool;
    
    func prepareForContext(context: CGContextRef)
    
    func drawAtPoint(point: CGPoint, path: CGMutablePathRef)
}

class BaseBrush : NSObject, PaintBrush {
    var beginPoint: CGPoint!
    var fillColor: CGColorRef!
    var strokeColor: CGColorRef!
    
    func supportedContinuousDrawing() -> Bool {
        return false
    }
    
    func prepareForContext(context: CGContextRef) {
        // ...
    }
    
    func drawAtPoint(point: CGPoint, path: CGMutablePathRef) {
        // ...
    }
}