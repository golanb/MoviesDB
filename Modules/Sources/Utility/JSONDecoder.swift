//
//  File.swift
//  
//
//  Created by Golan Bar-Nov on 21/04/2024.
//

import Foundation

public extension JSONDecoder {
    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return decoder
    }
}
