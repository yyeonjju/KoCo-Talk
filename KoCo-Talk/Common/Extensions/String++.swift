//
//  String++.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/31/25.
//

import Foundation

extension String {
    func serverDateConvertTo(_ format : DateFormatter.FormatString) -> String {
        //String -> Date
        let serverDateFormatter = DateFormatter.getServerDateFormatter()
        let date : Date = serverDateFormatter.date(from: self) ?? Date()
        
        //Date -> String
        let dateFormatterForString = DateFormatter.getKRLocaleDateFormatter(format: format)
        let dateString = dateFormatterForString.string(from: date)
        
        return dateString
    }
}
