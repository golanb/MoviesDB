//
//  File.swift
//  
//
//  Created by Golan Bar-Nov on 10/04/2024.
//

import Foundation

extension Network {
    public struct Token {
        let value: String
        
        static var tmdb: Token {
            // There are better ways for storing secrets but it's out of scope for this app
            Token(value: Bundle.infoPlistString(forKey: "TMDB_TOKEN")!)
        }
    }
}

extension Bundle {
    static func infoPlistValue<T>(forKey key: String) -> T? {
        Bundle.main.object(forInfoDictionaryKey: key) as? T
    }
    
    static func infoPlistString(forKey key: String) -> String? {
        infoPlistValue(forKey: key)
    }
}
