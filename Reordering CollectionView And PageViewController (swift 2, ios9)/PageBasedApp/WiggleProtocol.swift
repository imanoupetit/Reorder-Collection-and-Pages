//
//  WiggleProtocol.swift
//  PageBasedApp
//
//  Created by Imanou Petit on 16/10/2016.
//  Copyright © 2016 Imanou Petit. All rights reserved.
//

import UIKit

/// This protocol aims to add wiggling animation for UICollectionViewCells

protocol WiggleProtocol {}

extension WiggleProtocol where Self: UICollectionViewCell {
    
    /**
     Toggle between wiggling and not wiggling state.
     - Parameter state: A `Bool` indicating if we should start or stop wiggling.
     */
    func toggleWigglingFromState(state: Bool) {
        state ? startWiggling() : stopWiggling()
    }
    
    func startWiggling() {
        func randomInterval(interval: NSTimeInterval, variance: Double) -> NSTimeInterval {
            return interval + variance * Double((Double(arc4random_uniform(1000)) - 500.0) / 500.0)
        }
        
        // Early escape if animations are already set
        guard contentView.layer.animationForKey("wiggle") == nil else { return }
        guard contentView.layer.animationForKey("bounce") == nil else { return }
        
        let angle = 0.04
        
        let wiggle = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        wiggle.values = [-angle, angle]
        
        wiggle.autoreverses = true
        wiggle.duration = randomInterval(0.1, variance: 0.025)
        wiggle.repeatCount = Float.infinity
        
        contentView.layer.addAnimation(wiggle, forKey: "wiggle")
        
        let bounce = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounce.values = [4.0, 0.0]
        
        bounce.autoreverses = true
        bounce.duration = randomInterval(0.12, variance: 0.025)
        bounce.repeatCount = Float.infinity
        
        contentView.layer.addAnimation(bounce, forKey: "bounce")
    }
    
    func stopWiggling() {
        contentView.layer.removeAllAnimations()
    }
    
}
