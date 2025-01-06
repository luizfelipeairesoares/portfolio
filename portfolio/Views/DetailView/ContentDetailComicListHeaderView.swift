//
//  ContentDetailComicListHeaderView.swift
//  portfolio
//
//

import SwiftUI

struct ContentDetailComicListHeaderView: View {

    private let numberOfComics: String
    private let destinationView: ComicView

    public init(
        numberOfComics: String,
        destinationView: ComicView
    ) {
        self.numberOfComics = numberOfComics
        self.destinationView = destinationView
    }

    var body: some View {
        HStack(spacing: 8) {
            Text(numberOfComics)
                .foregroundColor(.black)
                .font(.headline)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(
                    EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 8)
                )
            NavigationLink {
                destinationView
            } label: {
                Text("See full list here")
                    .foregroundColor(.blue)
                    .font(.body)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .trailing
                    )
                    .padding(
                        EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 16)
                    )
            }
        }
    }

}
