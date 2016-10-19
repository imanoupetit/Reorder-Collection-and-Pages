//
//  ReorderProtocol.swift
//  PageBasedApp
//
//  Created by Imanou Petit on 18/10/2016.
//  Copyright © 2016 Imanou Petit. All rights reserved.
//

import UIKit

protocol ReorderProtocol {
    
    var collectionView: UICollectionView! { get }
    var model: Model { get }
    var pageDataSource: PageDataSource! { get }
    var gesture: UILongPressGestureRecognizer { get }
    
}

@available(iOS 9, *)
extension ReorderProtocol where Self: UIViewController {
    
    func handleBeganState(withLocation location: CGPoint) {
        // Manage wiggle by trigerring editing state
        setEditing(true, animated: true)
        
        // Manage interactive movement for collection view
        guard let indexPath = collectionView.indexPathForItemAtPoint(location) else { return }
        collectionView.beginInteractiveMovementForItemAtIndexPath(indexPath)
        
        // Manage picked up cell's animations
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CollectionViewCell else { return }
        cell.animatePickUp()
    }
    
    func handleChangedState(withLocation location: CGPoint) {
        // Manage interactive movement for collection view
        let location = gesture.locationInView(collectionView)
        collectionView.updateInteractiveMovementTargetPosition(location)
    }
    
    func handleEndedState(withLocation location: CGPoint) {
        // Manage wiggle
        setEditing(false, animated: true)
        
        // Manage interactive movement for collection view
        collectionView.endInteractiveMovement()
        
        // Upload pageViewController's pageDataSource as model changed
        // The following code will empty the page view controller's cache to prevent invalid paged view controller to appear on future scroll
        // http://stackoverflow.com/a/21624169/1966109
        guard let pageViewController = childViewControllers.first as? PageViewController else { fatalError("Could not load pageViewController") }
        pageViewController.dataSource = nil
        pageViewController.dataSource = pageDataSource
        
        // Manage picked up cell's animations
        guard let indexPath = collectionView.indexPathForItemAtPoint(location), cell = collectionView.cellForItemAtIndexPath(indexPath) as? CollectionViewCell else { return }
        cell.animatePutDown()
        
        // Update model
        // The collectionView selected indexPath is updated when the collectionView is reordered; pass it to model.selectedIndexPath
        if let indexPath = collectionView.indexPathsForSelectedItems()?.first {
            model.selectedIndexPath = indexPath
        }
    }
    
    func handleCancelledState(withLocation location: CGPoint) {
        // Manage wiggle
        setEditing(false, animated: true)
        
        // Manage interactive movement for collection view
        collectionView.cancelInteractiveMovement()
        
        // Manage picked up cell's animations
        guard let indexPath = collectionView.indexPathForItemAtPoint(location), cell = collectionView.cellForItemAtIndexPath(indexPath) as? CollectionViewCell else { return }
        cell.animatePutDown()
    }
    
}
