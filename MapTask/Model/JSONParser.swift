//
//  JSONParser.swift
//  MapKitTask
//
//  Created by Nikolay Sereda on 18.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import Foundation

class JSONParser {
    private let url: URL
    
    init(urlString: String) {
        url = URL(string: "file://\(urlString)")!
    }
    
    func parseJSON() -> [Any] {
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
           
            let sightsData = json["data"] as? [Any] ?? []
            
            return sightsData
        } catch {
            fatalError("JSON parse error: \(error)")
        }
        
    }
}
