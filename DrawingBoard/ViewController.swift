//
//  ViewController.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-15.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var brushes = [PencilBrush(), LineBrush(), DashLineBrush(), RectangleBrush(), EllipseBrush(), EraserBrush()]
    
    @IBOutlet var board: Board!
    @IBOutlet var topView: UIView!
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet var topViewConstraintY: NSLayoutConstraint!
    @IBOutlet var toolbarConstraintBottom: NSLayoutConstraint!
    @IBOutlet var toolbarConstraintHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.board.brush = brushes[0]
        
        let brushSettingView = UINib(nibName: "PaintingBrushSettingView", bundle: nil).instantiateWithOwner(nil, options: nil).first as PaintingBrushSettingView
        brushSettingView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.toolbar.addSubview(brushSettingView)
        self.toolbar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[settingView]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["settingView" : brushSettingView]))
        self.toolbar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[settingView]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["settingView" : brushSettingView]))
        brushSettingView.hidden = true
        brushSettingView.tag = 1
        brushSettingView.strokeWidthChangedBlock = {
            [unowned self] (strokeWidth: CGFloat) -> Void in
            self.board.strokeWidth = strokeWidth
        }
        brushSettingView.strokeColorChangedBlock = {
            [unowned self] (strokeColor: UIColor) -> Void in
            self.board.strokeColor = strokeColor
        }
        
        self.board.drawingStateChangedBlock = {(state: DrawingState) -> () in
            if state == .Began {
                self.topViewConstraintY.constant = -self.topView.frame.size.height
                self.toolbarConstraintBottom.constant = -self.toolbar.frame.size.height
                UIView.beginAnimations(nil, context: nil)
                
                self.topView.layoutIfNeeded()
                self.toolbar.layoutIfNeeded()
                
                UIView.commitAnimations()
            } else if state == .Ended {
                self.topViewConstraintY.constant = 0
                self.toolbarConstraintBottom.constant = 0
                UIView.beginAnimations(nil, context: nil)
                
                self.topView.layoutIfNeeded()
                self.toolbar.layoutIfNeeded()
                
                UIView.commitAnimations()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchBrush(sender: UISegmentedControl) {
        assert(sender.tag < self.brushes.count, "!!!")
        
        self.board.brush = self.brushes[sender.selectedSegmentIndex]
    }
    
    @IBAction func paintingBrushSettings() {
        
        self.toolbarConstraintHeight.constant = 300
        
        self.toolbar.setItems(nil, animated: true)
        UIView.beginAnimations(nil, context: nil)
        self.toolbar.layoutIfNeeded()
        UIView.commitAnimations()
        
        self.toolbar.viewWithTag(1)?.hidden = false
    }
}


