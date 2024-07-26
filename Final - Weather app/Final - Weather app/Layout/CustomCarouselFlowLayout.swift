//
//  CustomCarouselFlowLayout.swift
//  Final - Weather app
//
//  Created by Luka Khokhiashvili on 17.07.24.
//

import UIKit

class CustomCarouselFlowLayout: UICollectionViewFlowLayout {
    let itemHeightFactor: CGFloat = 1
    let scaleFactor: CGFloat = 0.93
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let itemWidth = collectionView.bounds.width * scaleFactor
        let itemHeight = collectionView.bounds.height * itemHeightFactor
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        sectionInset = UIEdgeInsets(top: 0, left: (collectionView.bounds.width - itemWidth) / 2, bottom: 0, right: (collectionView.bounds.width - itemWidth) / 2)
        minimumLineSpacing = 0
        scrollDirection = .horizontal
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach { attributes in
            let centerX = collectionView!.contentOffset.x + collectionView!.bounds.size.width / 2
            let distance = abs(attributes.center.x - centerX)
            let ratio = distance / (collectionView!.bounds.size.width / 2)
            let scale = 1 - ratio * (1 - scaleFactor)
            let alpha = 1 - ratio * (1 - scaleFactor)
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
            attributes.alpha = alpha
        }
        
        return layoutAttributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
        let layoutAttributes = super.layoutAttributesForElements(in: targetRect)
        
        let centerX = proposedContentOffset.x + collectionView.bounds.size.width / 2
        
        let closest = layoutAttributes?.sorted { abs($0.center.x - centerX) < abs($1.center.x - centerX) }.first ?? UICollectionViewLayoutAttributes()
        
        return CGPoint(x: closest.center.x - collectionView.bounds.size.width / 2, y: proposedContentOffset.y)
    }
}
