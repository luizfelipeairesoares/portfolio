//
//  ComicView.swift
//  portfolio
//
//

import SwiftUI
import Combine

struct ComicView: View {

    @ObservedObject var viewModel: ComicViewModel
    @State private var position: Int?

    init(viewModel: ComicViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2) 
                .ignoresSafeArea()
            if viewModel.isLoadingPage {
                ProgressView()
            } else {
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 8) {
                            ForEach(0..<viewModel.comics.count, id: \.self) { index in
                                ComicCardView(comic: viewModel.comics[index])
                                    .id(index)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $position)
                    .onChange(of: position) {
                        viewModel.loadMoreContent($position.wrappedValue ?? 0)
                    }
                    Text("Showing \($position.wrappedValue ?? 0) of \(viewModel.total)")
                        .font(.footnote)
                        .frame(alignment: .center)
                        .padding([.top, .bottom], 8)
                }
            }
        }
        .onAppear {
            viewModel.loadContent()
        }
        .navigationTitle("Comics")
    }

}

#Preview {
    let viewModel = ComicViewModel(characterId: 1017100)
    ComicView(viewModel: viewModel)
}
