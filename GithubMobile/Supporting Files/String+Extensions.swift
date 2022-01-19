//
//  String+Extensions.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/18/22.
//

import Foundation


extension String {
    
    func formatDateStringToMMDDyyyy(dateFormat format: String) -> Date {
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let serverDate = serverDateFormatter.date(from: self) else { return Date() }
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        let dateString = dateFormater.string(from: serverDate)
        guard let formatedDate = dateFormater.date(from: dateString) else {
            return Date()
        }
        return formatedDate
    }
}
