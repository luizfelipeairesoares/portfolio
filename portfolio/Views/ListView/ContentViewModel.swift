//
//  ContentViewModel.swift
//  portfolio
//
//

import Foundation
import Combine

class ContentViewModel: ObservableObject, Identifiable {

    @Published var filteredDatasource: [Characters]
    @Published var isLoadingPage = false
    @Published var searchText: String = ""

    private var datasource: [Characters]
    private var cancellables = [AnyCancellable]()
    private var currentPage: Int = 0
    private var canLoadMorePages = false

    // MARK: - Init

    public init() {
        filteredDatasource = []
        datasource = []
    }

    // MARK: - Public

    func loadContent(_ item: Characters? = nil) {
        isLoadingPage = datasource.isEmpty ? true : false
        guard let character = item else {
            request()
            return
        }

        let thresholdIndex = datasource.index(datasource.endIndex, offsetBy: -5)
        if datasource.firstIndex(where: { $0.id == character.id }) == thresholdIndex {
            request()
        }
    }

    func showCharacter(selected: Characters) -> ContentDetailView {
        let viewModel = ContentDetailViewModel(character: selected)
        return ContentDetailView(viewModel: viewModel)
    }

    func searchCaracter() {
        guard !searchText.isEmpty else {
            filteredDatasource = datasource
            return
        }
        isLoadingPage = true
        search()
    }

    // MARK: - Private

    private func request() {
        CharactersService().listCharacters(page: currentPage)
            .map({  $0.data })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("oops got an error \(error.localizedDescription)")
                case .finished:
                    self?.isLoadingPage = false
                }
            }, receiveValue: { [weak self] response in
                self?.currentPage += response.count
                self?.datasource.append(contentsOf: response.results)
                self?.filteredDatasource = self?.datasource ?? []
            })
            .store(in: &cancellables)
    }

    private func search() {
        CharactersService().searchCharacter(searchText: searchText)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("oops got an error \(error.localizedDescription)")
                case .finished:
                    self?.isLoadingPage = false
                }
            }, receiveValue: { [weak self] response in
                self?.currentPage += response.count
                self?.filteredDatasource.removeAll()
                self?.filteredDatasource.append(contentsOf: response.results)
            })
            .store(in: &cancellables)
    }

}
