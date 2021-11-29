//
//  CustomTextField.swift
//  VKFeed
//
//  Created by Артем Хребтов on 29.11.2021.
//

import Foundation
import UIKit


class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        placeholder = "Поиск"
        font = UIFont.systemFont(ofSize: 14)
        clearButtonMode = .whileEditing
        borderStyle = .none
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        let image = UIImage(systemName: "magnifyingglass")
        leftView = UIImageView(image: image)
        leftView?.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        leftViewMode = .always
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
}
