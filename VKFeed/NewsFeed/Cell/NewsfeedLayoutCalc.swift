//
//  NewsfeedLayoutCalc.swift
//  VKFeed
//
//  Created by Артем Хребтов on 04.11.2021.
//

import Foundation
import UIKit

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var attachmentFrame: CGRect
    var bottomView: CGRect
    var totalHeight: CGFloat
    var moreButton: CGRect
}


protocol FeedCellLayoutCalculatorProtocol{
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)){
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes {

        var showMoreButton = false
        
        let cardViewWidth = screenWidth - Constants.cardInserts.left - Constants.cardInserts.right
        // MARK: Работа с postLabelFrame
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left, y: Constants.postLabelInsets.top), size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let widht = cardViewWidth - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            var height = text.height(width: widht, font: Constants.postLabelFont)
            let limitHeights = Constants.postLabelFont.lineHeight * Constants.postLimitsLines
            
            if height>limitHeights {
                height = Constants.postLabelFont.lineHeight * Constants.postLines
                showMoreButton = true
            }
            
            postLabelFrame.size = CGSize(width: widht, height: height)
        }
        //moreButton
        var moreButtonSize = CGSize.zero
        
        if showMoreButton {
            moreButtonSize = Constants.moreButtonSize
        }
        
        let moreButtonOrigin = CGPoint(x: Constants.moreButtonsInserts.left, y: postLabelFrame.maxY)
        let moreButtonFrame = CGRect(origin: moreButtonOrigin, size: moreButtonSize)
        
        
        let attachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : moreButtonFrame.maxY + Constants.postLabelInsets.bottom
        
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize.zero)
        
        if let attachment = photoAttachment {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = CGFloat(photoHeight / photoWidth)
            attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
        }
        
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop),
                                     size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        let totalHeight = bottomViewFrame.maxY + Constants.cardInserts.bottom
        
        return Sizes(postLabelFrame: postLabelFrame,
                     attachmentFrame: attachmentFrame,
                     bottomView: bottomViewFrame,
                     totalHeight: totalHeight,
                     moreButton: moreButtonFrame)
    }
}

