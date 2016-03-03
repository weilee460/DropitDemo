//
//  BezierPathsView.swift
//  DropitDemo
//
//  Created by ying on 16/3/3.
//  Copyright © 2016年 ying. All rights reserved.
//

import UIKit

class BezierPathsView: UIView {

    private var bezierPaths = [String: UIBezierPath]()
    
    func setPath(path: UIBezierPath?, named name: String)
    {
        bezierPaths[name] = path
        setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPaths
        {
            path.stroke()
        }
        
    }

}
