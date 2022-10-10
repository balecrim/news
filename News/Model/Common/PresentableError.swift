//
//  PresentableError.swift
//  News
//
//  Created by Bernardo Alecrim on 06/10/2022.
//

import SwiftUI

protocol PresentableError: Error {
    var icon: Image { get }
    var friendlyDescription: String { get }
}
