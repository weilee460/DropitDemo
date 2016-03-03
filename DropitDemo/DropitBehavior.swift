//
//  DropitBehavior.swift
//  DropitDemo
//
//  Created by ying on 16/3/3.
//  Copyright © 2016年 ying. All rights reserved.
//

import UIKit

class DropitBehavior: UIDynamicBehavior {

    //Add gravity
    let gravity = UIGravityBehavior()
    //As same reason.
    lazy var collider: UICollisionBehavior = {
        let lazilyCratedCollider = UICollisionBehavior()
        lazilyCratedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCratedCollider
    }()
    
    lazy var dropBehavior: UIDynamicItemBehavior = {
        let lazilyCreateDropBehavior = UIDynamicItemBehavior()
        lazilyCreateDropBehavior.allowsRotation = true
        lazilyCreateDropBehavior.elasticity = 0.75 //1 - completely not loss energy
        return lazilyCreateDropBehavior
    }()
    
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(dropBehavior)
    }
    
    func addDrop(drop: UIView)
    {
        dynamicAnimator?.referenceView?.addSubview(drop)
        gravity.addItem(drop)
        collider.addItem(drop)
        dropBehavior.addItem(drop)
    }
    
    func removeDrop(drop: UIView)
    {
        gravity.removeItem(drop)
        collider.removeItem(drop)
        dropBehavior.removeItem(drop)
        drop.removeFromSuperview()
    }
}
