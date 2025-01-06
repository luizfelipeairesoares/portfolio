//
//  ComicViewModel.swift
//  portfolio
//
//

import Foundation
import Combine

class ComicViewModel: ObservableObject, Identifiable {

    @Published var comics: [Comic]
    @Published var isLoadingPage = false

    private(set) var total: Int = 0

    private let characterId: Int
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 0

    public init(characterId: Int) {
        self.characterId = characterId
        self.comics = []
    }

    // MARK: - Public

    func loadContent() {
        isLoadingPage = true
        requestComic()
    }

    func loadMoreContent(_ index: Int) {
        if comics.count-index < 5 {
            requestComic()
        }
    }

    // MARK: - Private

    private func requestComic() {
        CharactersService()
            .charactersComics(id: "\(characterId)", page: currentPage)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("oops got an error \(error.localizedDescription)")
                case .finished:
                    self?.isLoadingPage = false
                }
            } receiveValue: { [weak self] response in
                self?.comics.append(contentsOf: response.results)
                self?.total = response.total
                self?.currentPage += response.count
            }
            .store(in: &cancellables)
    }

}
