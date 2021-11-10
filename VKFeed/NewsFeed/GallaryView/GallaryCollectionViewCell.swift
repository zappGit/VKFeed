//
//  GallaryCollectionViewCell.swift
//  VKFeed
//
//  Created by Артем Хребтов on 10.11.2021.
//

import Foundation
import UIKit

class GallaryCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "GCVC"
    
    let myImageView: WebImageView = {
        let image = WebImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return image
    }()
    override init(frame: CGRect){
        super .init(frame: frame)
        //backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        //image View constraints
        addSubview(myImageView)
        myImageView.fillSuperview()
    }
    
    override func prepareForReuse() {
        myImageView.image = nil
    }
    
    func set(imageUrl: String?){
        myImageView.set(imgUrl: imageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
