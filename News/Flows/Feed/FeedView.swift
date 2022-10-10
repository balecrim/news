//
//  FeedView.swift
//  News
//
//  Created by Bernardo Alecrim on 06/10/2022.
//

import SwiftUI

struct FeedView: View {
    @StateObject var feedViewModel = FeedViewModel()

    var body: some View {
        NavigationView {
            buildView(for: feedViewModel.state)
                .navigationTitle("Feed")
                .refreshable { Task { await feedViewModel.refresh() } }
                .onAppear { Task { await feedViewModel.refresh() } }
        }
    }
}

private extension FeedView {
    @ViewBuilder
    func buildView(for state: FeedViewModel.State) -> some View {
        switch state {
        case .loading:
            ProgressView()
        case let .loaded(cardModels):
            buildListView(models: cardModels)
        case let .error(presentableError):
            buildErrorView(from: presentableError)
        }
    }

    func buildListView(models cards: [NewsCardView.Model]) -> some View {
        List {
            ForEach(cards) { cardModel in
                Section {
                    NewsCardView(model: cardModel)
                }
                .onTapGesture {
                    feedViewModel.articleTapped(model: cardModel)
                }
            }
            .listRowSeparator(.hidden)
        }
        .sheet(isPresented: feedViewModel.isPresentingSheet) {
            buildSafariView(for: feedViewModel.sheetState)
        }
    }

    func buildSafariView(for state: FeedViewModel.SheetState) -> some View {
        guard case let .presenting(url) = self.feedViewModel.sheetState else {
            assertionFailure("reached sheet builder in invalid state")
            return AnyView(Text("missing URL"))
        }

        return AnyView(SafariView(url: url))
    }

    func buildErrorView(from presentableError: PresentableError) -> some View {
        VStack(alignment: .center) {
            presentableError.icon
            Spacer()
                .frame(maxHeight: 16)
            Text(presentableError.friendlyDescription)
                .multilineTextAlignment(.center)
        }.padding(20)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
