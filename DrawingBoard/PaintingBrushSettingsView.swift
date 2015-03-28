//
//  PaintingBrushSettingsView.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-3-28.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit


class PaintingBrushSettingsView : UIView {
    
    var strokeWidthChangedBlock: ((strokeWidth: CGFloat) -> Void)?
    var strokeColorChangedBlock: ((strokeColor: UIColor) -> Void)?
    
    @IBOutlet private var strokeWidthSlider: UISlider!
    @IBOutlet private var strokeColorPreview: UIView!
    @IBOutlet private var strokeColorRedSlider: UISlider!
    @IBOutlet private var strokeColorGreenSlider: UISlider!
    @IBOutlet private var strokeColorBlueSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.strokeColorPreview.layer.borderColor = UIColor.blackColor().CGColor
        self.strokeColorPreview.layer.borderWidth = 1
        
        self.strokeWidthSlider.addTarget(self, action: "strokeWidthChanged:", forControlEvents:.ValueChanged)
        self.strokeColorRedSlider.addTarget(self, action: "strokeColorChanged:", forControlEvents:.ValueChanged)
        self.strokeColorGreenSlider.addTarget(self, action: "strokeColorChanged:", forControlEvents:.ValueChanged)
        self.strokeColorBlueSlider.addTarget(self, action: "strokeColorChanged:", forControlEvents:.ValueChanged)
        
        self.strokeColorRedSlider.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    func strokeWidthChanged(slider: UISlider) {
        if let strokeWidthChangedBlock = self.strokeWidthChangedBlock {
            strokeWidthChangedBlock(strokeWidth: CGFloat(slider.value))
        }
    }
    
    @IBAction func strokeColorChanged(slider: UISlider) {
        self.strokeColorPreview.backgroundColor = UIColor(
            red: CGFloat(self.strokeColorRedSlider.value / 255.0),
            green: CGFloat(self.strokeColorGreenSlider.value / 255.0),
            blue: CGFloat(self.self.strokeColorBlueSlider.value / 255.0),
            alpha: 1)
        
        let label = self.viewWithTag(slider.tag + 10) as UILabel
        label.text = NSString(format: "%.0f", slider.value)
        
        if let strokeColorChangedBlock = self.strokeColorChangedBlock {
            strokeColorChangedBlock(strokeColor: self.strokeColorPreview.backgroundColor!)
        }
    }
}