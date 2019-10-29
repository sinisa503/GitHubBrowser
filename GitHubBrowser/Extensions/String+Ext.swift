//
//  Date+Ext.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

extension String {
    
    func formattedDate() -> String {
        if let date = self.dateRepresentation() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
            let stringDate = dateFormatter.string(from: date)
            return stringDate
        }else {
            return self
        }
    }
    
    func dateRepresentation() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }else {
            return nil
        }
    }
}
