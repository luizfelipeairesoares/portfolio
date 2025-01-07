//
//  ContentDetailView.swift
//  portfolio
//
//

import SwiftUI

struct ContentDetailView: View {

    @ObservedObject var viewModel: ContentDetailViewModel

    public init(viewModel: ContentDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(
                url: viewModel.character.thumbnail?.imageURL,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                },
                placeholder: {
                    ProgressView()
                }
            )
            Text(viewModel.descriptionText())
                .foregroundColor(.black)
                .font(.subheadline)
                .frame(alignment: .center)
                .padding([.leading, .trailing], 16)
            if viewModel.character.comics.available > 0 {
                ContentDetailComicListHeaderView(
                    numberOfComics: viewModel.numberOfComicsText(),
                    destinationView: viewModel.showComics()
                )
            }
            List(viewModel.character.comics.items, id: \.name) { comic in
                Text(comic.name)
                    .foregroundColor(.black)
                    .font(.body)
                    .frame(alignment: .leading)
            }
            .scrollContentBackground(.hidden)
            .contentMargins(.top, 0)
        }
        .onAppear {
            viewModel.loadCharacter()
        }
        .background(Color.gray.opacity(0.2))
        .navigationTitle(viewModel.character.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
    }
}

#Preview {
    let character = Characters(
        id: 1,
        name: "Test",
        desc: "Description",
        resourceURI: nil,
        thumbnail: nil,
        comics: CharacterComics(
            available: 1,
            items: [CharacterComic(name: "Comic name")],
            returned: 1
        )
    )
    let viewModel = ContentDetailViewModel(character: character)
    ContentDetailView(viewModel: viewModel)
}
