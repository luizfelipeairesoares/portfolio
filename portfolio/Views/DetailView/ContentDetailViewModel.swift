//
//  ContentDetailViewModel.swift
//  portfolio
//
//

import Foundation
import Combine

class ContentDetailViewModel: ObservableObject, Identifiable {

    @Published var character: Characters

    private var cancellables = Set<AnyCancellable>()

    public init(character: Characters) {
        self.character = character
    }

    // MARK: - Public

    public func loadCharacter() {
        request(with: character.id)
    }

    public func descriptionText() -> String {
        guard let description = character.desc, !description.isEmpty else {
            return "No description available"
        }
        return description
    }

    public func numberOfComicsText() -> String {
        let number = character.comics.available
        var text = "Seen on \(number) "
        text += number == 1 ? "comic:" : "comics:"
        return text
    }

    public func showComics() -> ComicView {
        let viewModel = ComicViewModel(characterId: character.id)
        let view = ComicView(viewModel: viewModel)
        return view
    }

    // MARK: - Private

    private func request(with characterId: Int) {
        CharactersService().detailCharacter(id: "\(characterId)")
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("oops got an error \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let first = response.results.first else {
                    return
                }
                self?.character = first
            }
            .store(in: &cancellables)
    }

}
