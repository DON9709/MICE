//
//  SearchViewModel.swift
//  MICE
//
//  Created by 송명균 on 8/26/25.
//

import UIKit

struct SearchCategory {
    let title: String
    let iconName: String
    let selectedIconName: String
}

class SearchViewModel {
    
    let categories: [SearchCategory] = [
        SearchCategory(title: "박물관", iconName: "Museum", selectedIconName: "MuseumActive"),
        SearchCategory(title: "기념관", iconName: "MemorialHall", selectedIconName: "MemorialHallActive"),
        SearchCategory(title: "전시관", iconName: "Exhibition", selectedIconName: "ExhibitionActive"),
        SearchCategory(title: "미술관", iconName: "ArtGallery", selectedIconName: "ArtGalleryActive")
    ]

    
    private let allExhibitions: [SearchResult] = [
        SearchResult(imageName: "exhibition.dummy", placeName: "국립중앙박물관", category: "박물관", closedInfo: "매주 월요일 휴업", hoursInfo: "10:00 - 18:00", missionInfo: "진행중인 스탬프 미션: 1개"),
        SearchResult(imageName: "exhibition.dummy", placeName: "독립 기념관", category: "기념관", closedInfo: "매주 월요일 휴업", hoursInfo: "09:00 ~ 22:00", missionInfo: "진행중인 스탬프 미션: 1개"),
        SearchResult(imageName: "exhibition.dummy", placeName: "전쟁 기념관", category: "기념관", closedInfo: "매주 월요일 휴업", hoursInfo: "09:30 ~ 18:00", missionInfo: "진행중인 스탬프 미션: 1개"),
        SearchResult(imageName: "exhibition.dummy", placeName: "대림미술관", category: "미술관", closedInfo: "매주 월요일 휴업", hoursInfo: "11:00 - 19:00", missionInfo: "진행중인 스탬프 미션: 1개"),
    ]
    
    var recentSearches: [String] = ["경주 박물관"]
    
    // MARK: - State
    var selectedCategory: SearchCategory?
    var filteredResults: [SearchResult] = []
    var isSearching: Bool = false
    
    // MARK: - Logic
    func selectCategory(_ category: SearchCategory) {
        selectedCategory = category
        performSearch(with: "")
    }
    
    func performSearch(with query: String) {
        guard let category = selectedCategory else {
            filteredResults = []
            return
        }
        
        let categoryFiltered = allExhibitions.filter { $0.category == category.title }

        if query.isEmpty {
            filteredResults = categoryFiltered
        } else {
            filteredResults = categoryFiltered.filter { $0.placeName.lowercased().contains(query.lowercased()) }
        }
    }
    
    func addRecentSearch(term: String) {
        recentSearches.removeAll { $0 == term }
        recentSearches.insert(term, at: 0)
    }
    
    func removeRecentSearch(at index: Int) {
        recentSearches.remove(at: index)
    }
}
