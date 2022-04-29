//
//  ResizableView.swift
//  ImageCropper
//
//  Created by Hiren Bhadreshwara on 4/27/22.
//

import UIKit
class ResizableView: UIView {

    enum Edge {
         case topLeft, topRight, bottomLeft, bottomRight, none
     }

     static var edgeSize: CGFloat = 20.0
     private typealias `Self` = ResizableView

     var currentEdge: Edge = .none
     var touchStart = CGPoint.zero

     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         if let touch = touches.first {

             touchStart = touch.location(in: self)

             currentEdge = {
                 if self.bounds.size.width - touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
                     return .bottomRight
                 } else if touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize {
                     return .topLeft
                 } else if self.bounds.size.width-touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize {
                     return .topRight
                 } else if touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
                     return .bottomLeft
                 }
                 
                 return .none
             }()
         }
     }

     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
         if let touch = touches.first {
             let currentPoint = touch.location(in: self)
             let previous = touch.previousLocation(in: self)

             let originX = self.frame.origin.x
             let originY = self.frame.origin.y
             let width = self.frame.size.width
             let height = self.frame.size.height

             let deltaWidth = currentPoint.x - previous.x
             let deltaHeight = currentPoint.y - previous.y
             let minSize: CGFloat = 80.0
             switch currentEdge {
             case .topLeft:
                 if (width - deltaWidth) > minSize && (height - deltaHeight) > minSize {
                     self.frame = CGRect(x: originX + deltaWidth, y: originY + deltaHeight, width: width - deltaWidth, height: height - deltaHeight)
                 }
             case .topRight:
                 if (width + deltaWidth) > minSize && (height - deltaHeight) > minSize {
                     self.frame = CGRect(x: originX, y: originY + deltaHeight, width: width + deltaWidth, height: height - deltaHeight)
                 }
             case .bottomRight:
                 if (width + deltaWidth) > minSize && (height + deltaWidth) > minSize {
                     self.frame = CGRect(x: originX, y: originY, width: width + deltaWidth, height: height + deltaWidth)
                 }
             case .bottomLeft:
                 if (width - deltaWidth) > minSize && (height + deltaHeight) > minSize {
                     self.frame = CGRect(x: originX + deltaWidth, y: originY, width: width - deltaWidth, height: height + deltaHeight)
                 }
             default:
                 // Moving
                 print("Moving")
                 self.center = CGPoint(x: self.center.x + currentPoint.x - touchStart.x,
                                       y: self.center.y + currentPoint.y - touchStart.y)
             }
         }
     }

     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
         currentEdge = .none
     }
}
