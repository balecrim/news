//
//  HashIdentifiable.swift
//  News
//
//  Created by Bernardo Alecrim on 06/10/2022.
//

import Foundation

protocol HashIdentifiable: Hashable, Identifiable<Int> {}

extension HashIdentifiable {
    var id: Int {
        self.hashValue
    }
}
