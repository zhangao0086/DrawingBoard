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
    
    var toolbarEditingItems: [UIBarButtonItem]?
    var currentSettingsView: UIView?
    
    @IBOutlet var topViewConstraintY: NSLayoutConstraint!
    @IBOutlet var toolbarConstraintBottom: NSLayoutConstraint!
    @IBOutlet var toolbarConstraintHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.board.brush = brushes[0]
        
        self.toolbarEditingItems = [
            UIBarButtonItem(barButtonSystemItem:.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "完成", style:.Plain, target: self, action: "endSetting")
        ]
        self.toolbarItems = self.toolbar.items

        self.setupBrushSettingsView()
        self.setupBackgroundSettingsView()
        
        self.board.drawingStateChangedBlock = {(state: DrawingState) -> () in
            if state != .Moved {
                UIView.beginAnimations(nil, context: nil)
                if state == .Began {
                    self.topViewConstraintY.constant = -self.topView.frame.size.height
                    self.toolbarConstraintBottom.constant = -self.toolbar.frame.size.height
                    
                    self.topView.layoutIfNeeded()
                    self.toolbar.layoutIfNeeded()
                } else if state == .Ended {
                    self.topViewConstraintY.constant = 0
                    self.toolbarConstraintBottom.constant = 0
                    
                    self.topView.layoutIfNeeded()
                    self.toolbar.layoutIfNeeded()
                }
                UIView.commitAnimations()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBrushSettingsView() {
        let brushSettingsView = UINib(nibName: "PaintingBrushSettingsView", bundle: nil).instantiateWithOwner(nil, options: nil).first as PaintingBrushSettingsView
        
        self.addConstraintsToToolbarForSettingsView(brushSettingsView)
        
        brushSettingsView.hidden = true
        brushSettingsView.tag = 1
        brushSettingsView.setBackgroundColor(self.board.strokeColor)
        
        brushSettingsView.strokeWidthChangedBlock = {
            [unowned self] (strokeWidth: CGFloat) -> Void in
            self.board.strokeWidth = strokeWidth
        }

        brushSettingsView.strokeColorChangedBlock = {
            [unowned self] (strokeColor: UIColor) -> Void in
            self.board.strokeColor = strokeColor
        }
    }
    
    func setupBackgroundSettingsView() {
        let backgroundSettingsVC = UINib(nibName: "BackgroundSettingsVC", bundle: nil).instantiateWithOwner(nil, options: nil).first as BackgroundSettingsVC
        
        self.addConstraintsToToolbarForSettingsView(backgroundSettingsVC.view)
        
        backgroundSettingsVC.view.hidden = true
        backgroundSettingsVC.view.tag = 2
        backgroundSettingsVC.setBackgroundColor(self.board.backgroundColor!)
        
        self.addChildViewController(backgroundSettingsVC)
        
        backgroundSettingsVC.backgroundImageChangedBlock = {
            [unowned self] (backgroundImage: UIImage) in
            self.board.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        
        backgroundSettingsVC.backgroundColorChangedBlock = {
            [unowned self] (backgroundColor: UIColor) in
            self.board.backgroundColor = backgroundColor
        }
    }
    
    func addConstraintsToToolbarForSettingsView(view: UIView) {
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.toolbar.addSubview(view)
        self.toolbar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[settingsView]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["settingsView" : view]))
        self.toolbar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[settingsView(==height)]",
            options: .DirectionLeadingToTrailing,
            metrics: ["height" : view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height],
            views: ["settingsView" : view]))
    }
    
    func updateToolbarForSettingsView() {
        self.toolbarConstraintHeight.constant = self.currentSettingsView!.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 44
        
        self.toolbar.setItems(self.toolbarEditingItems, animated: true)
        UIView.beginAnimations(nil, context: nil)
        self.toolbar.layoutIfNeeded()
        UIView.commitAnimations()
        
        self.toolbar.bringSubviewToFront(self.currentSettingsView!)
    }

    @IBAction func switchBrush(sender: UISegmentedControl) {
        assert(sender.tag < self.brushes.count, "!!!")
        
        self.board.brush = self.brushes[sender.selectedSegmentIndex]
    }
    
    @IBAction func paintingBrushSettings() {
        self.currentSettingsView = self.toolbar.viewWithTag(1)
        self.currentSettingsView?.hidden = false
     
        self.updateToolbarForSettingsView()
    }

    @IBAction func backgroundSettings() {
        self.currentSettingsView = self.toolbar.viewWithTag(2)
        self.currentSettingsView?.hidden = false
        
        self.updateToolbarForSettingsView()
    }
    
    @IBAction func endSetting() {
        self.toolbarConstraintHeight.constant = 44
        
        self.toolbar.setItems(self.toolbarItems, animated: true)
        
        UIView.beginAnimations(nil, context: nil)
        self.toolbar.layoutIfNeeded()
        UIView.commitAnimations()
        
        self.currentSettingsView?.hidden = true
    }
}


