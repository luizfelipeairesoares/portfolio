//
//  ContentView.swift
//  portfolio
//
//

import SwiftUI
import Combine

struct ContentView: View {

    @ObservedObject var viewModel: ContentViewModel

    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            if viewModel.isLoadingPage {
                ProgressView()
                    .foregroundStyle(.black)
            } else {
                List(viewModel.filteredDatasource, id: \.id) { character in
                    NavigationLink {
                        viewModel.showCharacter(selected: character)
                    } label: {
                        details(for: ContentCharacterViewModel(character: character))
                            .onAppear {
                                viewModel.loadContent(character)
                            }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationTitle("Marvel Characters")
                .searchable(text: $viewModel.searchText, prompt: "Search Characters")
                .onSubmit(of: .search) {
                    viewModel.searchCaracter()
                }
                .onChange(of: viewModel.searchText, { oldValue, newValue in
                    if newValue.isEmpty {
                        viewModel.searchCaracter()
                    }
                })
            }
        }
        .onAppear {
            viewModel.loadContent()
        }
    }

    private func details(for viewModel: ContentCharacterViewModel) -> some View {
        ContentViewCharacterView(viewModel: viewModel)
    }

}
