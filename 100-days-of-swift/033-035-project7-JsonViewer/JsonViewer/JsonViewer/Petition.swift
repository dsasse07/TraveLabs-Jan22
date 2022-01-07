//
//  Petition.swift
//  JsonViewer
//
//  Created by Daniel Sasse on 1/7/22.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
