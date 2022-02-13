import UIKit


import Foundation

protocol BusSeatFlowLayoutDelegate: AnyObject {
    
    func seatView(_ collectionView: UICollectionView, heightForMusicAt indexPath: IndexPath) -> CGFloat
    
    func seatView(_ collectionView: UICollectionView, widthForMusicAt indexPath: IndexPath) -> CGFloat
    
    func seatView(_ collectionView: UICollectionView, sizeForSeatAt indexPath: IndexPath) -> CGSize
    
}

class BusSeatFlowLayout: UICollectionViewFlowLayout {
    
    var numberOfColumns: CGFloat = 4
    
    var cellPadding: CGFloat = 5.0
    
    let walkSpaceAtIndex = 2
    
    var pendingDrawItem: Int {
        Int(numberOfColumns) - walkSpaceAtIndex
    }
    
    private var contentHeight: CGFloat = 0.0
    
    private var walkSpace: CGFloat {
        let pendingSize = (CGFloat(pendingDrawItem) * itemSize.width)
        let result = contentWidth - pendingSize
        return result - (CGFloat(pendingDrawItem)*cellPadding)

    }
    
    private var contentWidth: CGFloat {
        let insect = collectionView!.contentInset
        return (collectionView!.bounds.width) - (insect.left + insect.right)
    }
    
    var delegate: BusSeatFlowLayoutDelegate?
    
    var delegateWidth = 0.0
    
    var passengerSeatSize: CGSize = CGSize(width: 50, height: 50)
    var busSeatSize: CGSize = CGSize(width: 270, height: 80)

    var attributeCache = [IndexPath:UICollectionViewLayoutAttributes]()

    /***
     1. Called whenever collectionView change: i.e rotation
     2. Intent to change the collectionView layout attribute
     */
    
    override func prepare() {
        
        /***
         1. we are going to calculate the x -offset (horizontal) of each columns or cell component.
         */

        //Check to don't have to re reacts
        
        if attributeCache.isEmpty {
            
            let width: CGFloat = itemSize.width
            
            //We have to columns to maintain x 0ffset
            
            var xOffsets = [CGFloat]()
            
            for column in 0..<Int(numberOfColumns) {
                
                let result = column.quotientAndRemainder(dividingBy: Int(numberOfColumns))
                
                if result.remainder == 0 {
                    xOffsets.append(CGFloat(column) * width)
                    
                } else if result.remainder == 2 {
                    xOffsets.append(walkSpace)
                    
                } else {
                    //xOffsets.append(20 + (width + walkSpace) + 50)
                    let result =  xOffsets.last! + itemSize.width + cellPadding
                    xOffsets.append(result)
                    
                }
                
            }
            
            /***
              maintain y-offset of each columns
             */
            
            var column = 0
            
            var yOffsets = [CGFloat](repeating: busSeatSize.height, count: Int(numberOfColumns))
            
            //enumerate the each item in section
            
            for section in 0..<collectionView!.numberOfSections {
                
                for item in 0..<collectionView!.numberOfItems(inSection: section) {
                    
                    /***
                     get index path of item in section
                     **/
                    
                    let indexPath = IndexPath(item: item, section: section)
                    
                    if section == 0 {
                        let frame = CGRect(x: 0, y: 0, width: busSeatSize.width, height: busSeatSize.height)
                        
                        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                        
                        
                        //create cell layout attribute
                        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        
                        
                        
                        //assgin the frame to attribute
                                                
                        attribute.frame = insetFrame
                        
                        
                        //stote in cahce
                        self.attributeCache[indexPath] = attribute

                        //
                        
                    } else {

                        
                        
                        //calculate the frame of attribute of cell
                    
                        let height: CGFloat = itemSize.height
                        
                        self.delegateWidth = width
                                                
                        let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: width, height: height)
                        
                        
                        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                        
                        
                        //create cell layout attribute
                        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        
                        
                        //assign the frame to attribute
                        
                        attribute.frame = insetFrame
                        
                        //store in cache
                        self.attributeCache[indexPath] = attribute
                        //
                        
                        
                        //update the column and y offset
                        
                        contentHeight = max(contentHeight, frame.maxY)
                        
                        yOffsets[column] = yOffsets[column] + height
                        
                        
                        if column >= Int(numberOfColumns) - 1 {
                            column = 0
                        } else {
                            column += 1
                        }
                    }
                }
            }
            
            
            
        }
    }
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: contentWidth, height: contentHeight)
        
    }
    

    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.attributeCache[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arrLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for (_,attributes) in self.attributeCache where rect.intersects(attributes.frame) {
            arrLayoutAttributes.append(attributes)
        }
        return arrLayoutAttributes
    }

}
