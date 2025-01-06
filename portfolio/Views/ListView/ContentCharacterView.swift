//
//  ContentCharacterView.swift
//  portfolio
//
//

import SwiftUI

struct ContentViewCharacterView: View {

    private let viewModel: ContentCharacterViewModel

    init(viewModel: ContentCharacterViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(spacing: 8) {
            AsyncImage(
                url: viewModel.characterImage,
                content: { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    case .failure, .empty:
                        Image(systemName: "photo")
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    @unknown default:
                        Image(systemName: "photo")
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    }
                }
            )
            .frame(width: 100, height: 100)
            Text(viewModel.characterName ?? "")
                .foregroundColor(.black)
        }
    }

}
