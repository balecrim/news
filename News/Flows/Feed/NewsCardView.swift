//
//  NewsCard.swift
//  News
//
//  Created by Bernardo Alecrim on 06/10/2022.
//

import SwiftUI

struct NewsCardView: View {
    struct Model: Equatable, HashIdentifiable {
        let title: String
        let preview: String?
        let imageURL: String?
        let articleURL: String
        let author: String
        let publicationDate: String
    }

    let model: Model

    var body: some View {
        buildHeroImage(urlString: model.imageURL, height: 180)
            .padding([.top, .leading, .trailing], -8)
        VStack(alignment: .leading) {
            Text(model.title)
                .font(.system(size: 14, weight: .medium))
            buildPreviewSection(previewText: model.preview)
        }
        HStack {
            buildInfoStack(imageName: "newspaper", text: model.author)
            Spacer(minLength: 32)
            buildInfoStack(imageName: "calendar", text: model.publicationDate)
        }
    }
}

private extension NewsCardView {
    @ViewBuilder
    func buildPreviewSection(previewText: String?) -> some View {
        if let previewText {
            Spacer()
            Text(previewText)
                .font(.system(size: 12, weight: .regular))
        }
    }

    func buildHeroImage(urlString: String?, height: CGFloat) -> some View {
        guard let urlString = urlString else {
            let view = Image(systemName: "rectangle.portrait.slash")
                .resizable()

            return AnyView(view)
        }

        let imageView = AsyncImage(url: URL(string: urlString)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaledToFill()
                .clipped()
        } placeholder: {
            ProgressView()
        }.frame(maxWidth: .infinity, minHeight: 180)

        return AnyView(imageView)
    }

    func buildInfoStack(imageName: String, text: String) -> some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 14, height: 14)
                .opacity(0.6)
            Text(text)
                .font(.footnote)
                .opacity(0.6)
        }
    }
}
