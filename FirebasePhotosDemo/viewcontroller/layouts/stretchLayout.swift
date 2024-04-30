import UIKit

class stretchLayout: UICollectionViewFlowLayout{
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect) as! [UICollectionViewLayoutAttributes]
        let offset = collectionView!.contentOffset
        if (offset.y < 0){
            let deltaY = fabs(offset.y)
            for attributes in layoutAttributes{
                if let elementKind = attributes.representedElementKind{
                    if elementKind == UICollectionView.elementKindSectionHeader{
                        var frame = attributes.frame
                        frame.size.height = max(0, headerReferenceSize.height + deltaY)
                        frame.origin.y = frame.minY - deltaY
                        attributes.frame = frame
                    }
                }
            }
            
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
