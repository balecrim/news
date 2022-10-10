//
//  SecretsProvider.swift
//  News
//
//  Created by Bernardo Alecrim on 10/10/2022.
//

import Foundation

final class SecretsProvider: SecretsProviding {
    lazy var apiKey: String? = fetchApiKey()

    private func fetchApiKey() -> String? {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let secrets = NSDictionary(contentsOf: url),
            let key = secrets["apiKey"] as? String,
            !key.isEmpty
        else {
            return nil
        }

        return key
    }
}
