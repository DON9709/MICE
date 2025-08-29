//
//  SearchViewModel.swift
//  MICE
//
//  Created by 송명균 on 8/26/25.
//

import Foundation

class SearchViewModel {
    
    // 1. View가 사용할 데이터
    // - 최근 검색어 (실제 앱에서는 UserDefaults 등으로 저장해야 합니다)
    var recentSearches: [String] = [
        "경주 박물관",
        "부산 아쿠아리움",
        "강릉 전시회"
    ]
    
    // - 하드코딩된 검색 결과 리스트
    let searchResults: [SearchResult] = [
            SearchResult(imageName: "exhibition.dummy", placeName: "아침고요수목원 국화전시회", closedInfo: "매주 월요일 휴업", hoursInfo: "09:00 ~ 22:00", missionInfo: "진행중인 스탬프 미션: 1개"),
            SearchResult(imageName: "exhibition.dummy", placeName: "국립중앙박물관", closedInfo: "매주 월요일 휴업", hoursInfo: "10:00 - 18:00", missionInfo: "진행중인 스탬프 미션: 1개"),
            SearchResult(imageName: "exhibition.dummy", placeName: "대림미술관", closedInfo: "매주 월요일 휴업", hoursInfo: "11:00 - 19:00", missionInfo: "진행중인 스탬프 미션: 1개")
        ]
    
    // 2. View의 상태를 관리하는 변수
    // - 검색 중인지 여부 (이 값에 따라 최근 검색어 / 검색 결과가 보입니다)
    var isSearching: Bool = false
    
    // 3. View를 위한 로직
    // - 최근 검색어 삭제
    func removeRecentSearch(at index: Int) {
        recentSearches.remove(at: index)
    }
    
    // - 최근 검색어 추가 (중복 제외)
    func addRecentSearch(term: String) {
        // 기존에 있다면 삭제 후 맨 위로 올립니다.
        recentSearches.removeAll { $0 == term }
        recentSearches.insert(term, at: 0)
    }
}
