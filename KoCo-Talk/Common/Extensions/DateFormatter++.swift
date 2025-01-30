//
//  DateFormatter++.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/30/25.
//

import Foundation

extension DateFormatter {
    enum FormatString : String {
//        case chatFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // "2025-01-26T07:14:54.357Z"
        case chatTimeFormat = "a h:mm"
        case chatDateFormat = "MMMM d일" //MMMM : 7 -> "7월"
    }
    
    // MARK: - DateFormatter 생성해놓고 재활용
    static private let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    static private let iso8601DateFormatter : ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    // MARK: - 생성해놓은 Formatter 반환하는 메서드
    static func getServerDateFormatter() -> ISO8601DateFormatter {
        let formatter = iso8601DateFormatter
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }
    
    static func getKRLocaleDateFormatter(format : FormatString) -> DateFormatter {
        let formatter = dateFormatter
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = format.rawValue
        return formatter
    }
}
