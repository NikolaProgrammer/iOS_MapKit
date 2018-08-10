//
//  JSONParser.swift
//  MapKitTask
//
//  Created by Nikolay Sereda on 18.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import Foundation

class JSONParser {
    private var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func parseJSON() -> [Any] {
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
           
            let sightsData = json["data"] as? [Any] ?? []
            
            return sightsData
        } catch {
            fatalError("\(error)")
        }
        
    }
}
