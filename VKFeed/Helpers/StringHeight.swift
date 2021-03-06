//
//  StringHeight.swift
//  VKFeed
//
//  Created by Артем Хребтов on 04.11.2021.
//

import Foundation
import UIKit

extension String {
    //позволяет получить высоту текста исходя из размера шрифта
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : font],
                                     context: nil)
        return ceil(size.height)
    }
}
