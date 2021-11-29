//
//  TitleView.swift
//  VKFeed
//
//  Created by Артем Хребтов on 29.11.2021.
//

import Foundation
import UIKit

protocol TitleViewViewModel {
    var photoxUrlString: String? { get }
}

class TitleView: UIView {
    private var myTextField = CustomTextField()
    
    private var myAvatar: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .orange
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func set(userViewModeL: TitleViewViewModel) {
        myAvatar.set(imgUrl: userViewModeL.photoxUrlString)
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(myTextField)
        addSubview(myAvatar)
        myConstraints()
    }
    
    private func myConstraints() {
        myAvatar.anchor(top: topAnchor,
                        leading: nil,
                        bottom: nil,
                        trailing: trailingAnchor,
                        padding: UIEdgeInsets(top: 4, left: 10, bottom: 10, right: 4))
        myAvatar.heightAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        myAvatar.widthAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        
        myTextField.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: bottomAnchor,
                           trailing: myAvatar.leadingAnchor,
                           padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 12))
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        myAvatar.layer.masksToBounds = true
        myAvatar.layer.cornerRadius = myAvatar.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
