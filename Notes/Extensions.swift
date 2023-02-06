//
//  Extensions.swift
//  Notes
//
//  Created by Айдимир Магомедов on 01.02.2023.
//

import Foundation
import UIKit

extension UIFont {
    public static let titleFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
    
    public static let mediumSizeBoldFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    public static let mediumSizeFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
    
    public static let smallSizeFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
    
    public static let smallSizeBoldFont = UIFont.systemFont(ofSize: 15, weight: .bold)
}

extension UITextField {
    public func createStandartField() -> UITextField {
        var standardField: UITextField = {
            let field = UITextField()
            field.placeholder = "..."
            field.textColor = .gray
            field.text = ""
            field.textAlignment = .center
            field.setLeftPaddingPoints(10)
            field.setRightPaddingPoints(30)
            field.textColor = .black
            field.backgroundColor = .textFieldLightGray
            field.layer.cornerRadius = 10
            field.layer.masksToBounds = true
            return field
        }()
        return standardField
    }
    
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIColor {
    public static let textFieldLightGray = UIColor(red: 0.248, green: 0.247, blue: 0.248, alpha: 0.2)
    
    public static let lightImageBackgroundGray = UIColor(red: 0.255, green: 0.255, blue: 0.255, alpha: 0.2)
}

extension Date {
    //    yyyy-MM-dd
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension String {
    func getDate(format: String) -> Date? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = format

        return dateFormatterGet.date(from: self)
    }
}

extension Encodable {
    func saveAsJsonData() -> Data? {
        do {
            let encoded = try JSONEncoder().encode(self)
            return encoded
        } catch {
            print(error)
            return nil
        }
    }
}
