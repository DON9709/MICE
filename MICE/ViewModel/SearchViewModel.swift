//
//  SearchViewModel.swift
//  MICE
//
//  Created by 송명균 on 8/26/25.
//

import Foundation
import Combine


enum StampCategoryType {
    case museum, artGallery, memorial, exhibition

    var range: ClosedRange<Int> {
        switch self {
        case .museum: return 1...79
        case .artGallery: return 80...128
        case .memorial: return 129...153
        case .exhibition: return 154...176
        }
    }
}

struct SearchCategory {
    let title: String
    let iconName: String
    let selectedIconName: String
    let type: StampCategoryType
}


@MainActor
class SearchViewModel {
    
    // UI에서 사용할 카테고리 정보
    let categories: [SearchCategory] = [
        SearchCategory(title: "박물관", iconName: "Museum", selectedIconName: "MuseumActive", type: .museum),
        SearchCategory(title: "기념관", iconName: "MemorialHall", selectedIconName: "MemorialHallActive", type: .memorial),
        SearchCategory(title: "전시관", iconName: "Exhibition", selectedIconName: "ExhibitionActive", type: .exhibition),
        SearchCategory(title: "미술관", iconName: "ArtGallery", selectedIconName: "ArtGalleryActive", type: .artGallery)
    ]

    private var allStamps: [Stamp] = []
    var recentSearches: [String] = ["국립중앙박물관", "독립기념관"]
    var selectedCategory: SearchCategory?

    
    @Published var searchQuery: String = ""
    @Published var filteredStamps: [Stamp] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // 0.5초 딜레이
            .removeDuplicates() // 중복된 검색어는 무시
            .sink { [weak self] query in
                self?.performSearch(with: query)
            }
            .store(in: &cancellables)
    }

    // MARK: - Data Fetching
    func fetchAllStamps() async throws {
        self.allStamps = try await StampService.shared.getAllStamps()
    }

    // MARK: - Logic
    func selectCategory(_ category: SearchCategory) {
        selectedCategory = category
        // 카테고리 변경 시, 현재 검색어를 사용하여 즉시 검색 실행
        performSearch(with: self.searchQuery)
    }
    
   
    private func performSearch(with query: String) {
        guard let category = selectedCategory else {
            self.filteredStamps = []
            return
        }
        
        let categoryFiltered = allStamps.filter { stamp in
            guard let stampNo = stamp.stampno else { return false }
            return category.type.range.contains(stampNo)
        }

        if query.isEmpty {
            self.filteredStamps = categoryFiltered
        } else {
            self.filteredStamps = categoryFiltered.filter {
                $0.title?.lowercased().contains(query.lowercased()) ?? false
            }
        }
    }
    
    func addRecentSearch(term: String) {
        recentSearches.removeAll { $0 == term }
        recentSearches.insert(term, at: 0)
    }
    
    func removeRecentSearch(at index: Int) {
        recentSearches.remove(at: index)
    }
    
    func updateBookmarkStatus(contentId: String, isBookmarked: Bool) {
        if let index = allStamps.firstIndex(where: { $0.contentid == contentId }) {
            allStamps[index].isBookmarked = isBookmarked
        }
        if let filteredIndex = filteredStamps.firstIndex(where: { $0.contentid == contentId }) {
            filteredStamps[filteredIndex].isBookmarked = isBookmarked
        }
    }
}
