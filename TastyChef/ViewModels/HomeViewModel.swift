//
//  HomeViewModel.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import Foundation
import Combine

enum RecipesViewState{
    case loading
    case loaded
    case error(Error)
    case empty
}

enum SortOption: String, CaseIterable, Identifiable {
    case popularity = "popularity"
    case healthiness = "healthiness"
    case price = "pricePerServing"
    case time = "time"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .popularity: return "Most Popular"
        case .healthiness: return "Healthiest"
        case .price: return "Budget-Friendly"
        case .time: return "Quick to Make"
        }
    }
    
    var icon: String {
        switch self {
        case .popularity: return "star.fill"
        case .healthiness: return "heart.fill"
        case .price: return "dollarsign.circle.fill"
        case .time: return "clock.fill"
        }
    }
}

class HomeViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var recipes: [Result] = []
    @Published var viewState: RecipesViewState = .empty
    @Published var isLoadingMore = false
    @Published var currentSortOption: SortOption = .popularity
    
    private var cancellables = Set<AnyCancellable>()
    private var currentParameters: [String: String] = [:]  // Store current parameters
    var limit: Int = 10
    var offset: Int = 0
    var networkManager: NetworkManagerActions!
    
    init(networkManager: NetworkManagerActions!) {
        self.networkManager = networkManager
        setUpSearch()
    }
    
    deinit {
            cancellables.forEach { $0.cancel() }
        }
    
    func setUpSearch() {
            $searchText
                .debounce(for: 0.5, scheduler: DispatchQueue.main)
                .removeDuplicates()
                .filter { !$0.isEmpty }
                .sink { [weak self] searchText in
                    Task {
                        await self?.fetchRecipes(parameters: ["query": searchText])
                    }
                }
                .store(in: &cancellables)
        }
    
    
    @MainActor
    func resetSearch() {
        searchText = ""
        recipes = []
        offset = 0
        currentParameters = [:]
        viewState = .empty
    }
    
    @MainActor
    func fetchRecipes(parameters: [String: String] = [:], isLoadingMore: Bool = false) async {
        if !isLoadingMore {
            viewState = .loading
            offset = 0  // Reset offset for new searches
            currentParameters = parameters  // Store parameters for load more
        }
        
        do {
            var finalParameters = parameters
            finalParameters["sort"] = currentSortOption.rawValue
            finalParameters["number"] = "\(limit)"
            finalParameters["offset"] = "\(offset)"
            
            let fetchedResults = try await networkManager.getDataFromWebService(
                url: APIEndpoints.recipes.createUrl(with: finalParameters),
                modelType: PopularRecipesModel.self
            )
            
            if isLoadingMore {
                recipes.append(contentsOf: fetchedResults.results)
            } else {
                recipes = fetchedResults.results
            }
            
            viewState = recipes.isEmpty ? .empty : .loaded
            
        } catch {
            print("Error fetching recipes: \(error.localizedDescription)")
            viewState = .error(error)
        }
        
        if isLoadingMore {
            self.isLoadingMore = false
        }
    }
    
    @MainActor
    func loadMore() async {
        guard !isLoadingMore else { return }
        
        isLoadingMore = true
        offset += limit
        
        await fetchRecipes(parameters: currentParameters, isLoadingMore: true)
    }
    
    func getPopularRecipes() async {
        currentParameters = [:]
        await fetchRecipes()
    }
    
    func getCuisine(cuisine: String) async {
        await fetchRecipes(parameters: ["cuisine": cuisine])
    }
    
    func getVegetarian() async {
        await fetchRecipes(parameters: ["diet": "vegetarian"])
    }
    
    @MainActor
    func changeSortOption(to option: SortOption) async {
        if currentSortOption != option {
            currentSortOption = option
            // Reload recipes with the new sort option
            await fetchRecipes(parameters: currentParameters)
        }
    }
}
