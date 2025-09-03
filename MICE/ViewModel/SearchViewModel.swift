//
//  SearchViewModel.swift
//  MICE
//
//  Created by 송명균 on 8/26/25.
//

import Foundation

// SearchViewController의 CategoryButton에서 사용됩니다.
enum StampCategoryType {
    case museum, artGallery, memorial, exhibition

    var range: ClosedRange<Int> {
        switch self {
        case .museum: return 1...79
        case .artGallery: return 80...128
        case .memorial: return 129...153
        case .exhibition: return 154...177
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

    // StampService에서 가져온 모든 스탬프 원본 데이터
    private var allStamps: [Stamp] = []
    
    // 현재 UI에 표시될, 필터링된 스탬프 데이터
    var filteredStamps: [Stamp] = []
    
    // 최근 검색어 목록
    var recentSearches: [String] = ["국립중앙박물관", "독립기념관"]
    
    // 현재 선택된 카테고리
    var selectedCategory: SearchCategory?

    // MARK: - Data Fetching
    func fetchAllStamps() async throws {
        // StampService를 통해 Supabase에서 데이터를 가져옵니다.
        self.allStamps = try await StampService.shared.getAllStamps()
    }

    // MARK: - Logic
    func selectCategory(_ category: SearchCategory) {
        selectedCategory = category
        // 카테고리 선택 시, 검색어 없이 먼저 필터링합니다.
        performSearch(with: "")
    }
    
    func performSearch(with query: String) {
        guard let category = selectedCategory else {
            filteredStamps = []
            return
        }
        
        // 1. 카테고리의 stampno 범위로 1차 필터링
        let categoryFiltered = allStamps.filter { stamp in
            guard let stampNo = stamp.stampno else { return false }
            return category.type.range.contains(stampNo)
        }

        // 2. 검색어가 없으면 1차 필터링 결과만 사용
        if query.isEmpty {
            filteredStamps = categoryFiltered
        } else {
            // 3. 검색어가 있으면, 1차 필터링 결과 내에서 이름으로 2차 필터링
            filteredStamps = categoryFiltered.filter {
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
    
    // ▼▼▼▼▼ 오류 해결을 위해 이 함수를 추가합니다 ▼▼▼▼▼
    // 로컬 데이터를 동기화하는 함수
    func updateBookmarkStatus(contentId: String, isBookmarked: Bool) {
        // 전체 데이터에서 해당 스탬프를 찾아 상태를 업데이트
        if let index = allStamps.firstIndex(where: { $0.contentid == contentId }) {
            allStamps[index].isBookmarked = isBookmarked
        }
        // 현재 필터링된 데이터에도 똑같이 업데이트
        if let filteredIndex = filteredStamps.firstIndex(where: { $0.contentid == contentId }) {
            filteredStamps[filteredIndex].isBookmarked = isBookmarked
        }
    }
}
