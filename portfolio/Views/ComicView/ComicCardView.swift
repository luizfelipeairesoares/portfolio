//
//  ComicCardView.swift
//  portfolio
//
//

import SwiftUI


struct ComicCardView: View {

    private let comic: Comic

    init(comic: Comic) {
        self.comic = comic
    }

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(
                url: comic.thumbnail?.imageURL,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView()
                }
            )
            .shadow(
                color: .black.opacity(0.6),
                radius: 1,
                x: 4,
                y: 4
            )
            Text(comic.title)
                .foregroundColor(.black)
                .font(.title)
                .frame(alignment: .center)
                .padding([.leading, .trailing], 16)
            if !comic.description.isEmpty {
                ScrollView(.vertical) {
                    Text(comic.description)
                        .foregroundColor(.black)
                        .font(.body)
                        .frame(alignment: .leading)
                        .padding([.leading, .trailing], 16)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: 200
                )
            }
        }
        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
    }

}

#Preview {
    let comic = Comic(
        id: 1,
        digitalId: 1,
        title: "Comic Test",
        issueNumber: 1,
        description: "Test Comic #1 Edition Test Comic #1 Edition Test Comic #1 Edition Test Comic #1 Edition Test Comic #1 Edition Test Comic #1 Edition Test Comic #1 Edition Test Comic #1 Edition",
        isbn: "",
        pageCount: 74,
        thumbnail: MarvelImage(path: "http://i.annihil.us/u/prod/marvel/i/mg/9/50/57ed5bc9040e3", ext: "jpg"),
        creators: Creators(available: 0, returned: 0, items: [])
    )
    ComicCardView(comic: comic)
}
