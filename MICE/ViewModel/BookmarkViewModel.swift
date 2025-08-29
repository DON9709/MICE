//
//  BookmarkViewModel.swift
//  MICE
//
//  Created by 송명균 on 8/28/25.
//

import Foundation

class BookmarkViewModel {
    
    let savedStamps: [SearchResult] = [
        // 각 항목에 category를 추가해주세요.
        SearchResult(imageName: "exhibition.dummy", placeName: "아침고요수목원 국화전시회", category: "전시관", closedInfo: "매주 월요일 휴업", hoursInfo: "09:00 ~ 22:00", missionInfo: "진행중인 스탬프 미션: 1개"),
        SearchResult(imageName: "exhibition.dummy", placeName: "경주 박물관", category: "박물관", closedInfo: "매주 월요일 휴업", hoursInfo: "09:00 ~ 22:00", missionInfo: "진행중인 스탬프 미션: 1개"),
        SearchResult(imageName: "exhibition.dummy", placeName: "부산 시립미술관", category: "미술관", closedInfo: "매주 월요일 휴업", hoursInfo: "10:00 - 18:00", missionInfo: "진행중인 스탬프 미션: 1개")
    ]
    
    let visitedStamps: [SearchResult] = [
        // 여기도 마찬가지로 category를 추가해주세요.
        SearchResult(imageName: "exhibition.dummy", placeName: "국립중앙박물관", category: "박물관", closedInfo: "매주 월요일 휴업", hoursInfo: "10:00 - 18:00", missionInfo: "스탬프 미션 완료"),
        SearchResult(imageName: "exhibition.dummy", placeName: "대림미술관", category: "미술관", closedInfo: "매주 월요일 휴업", hoursInfo: "11:00 - 19:00", missionInfo: "스탬프 미션 완료"),
        SearchResult(imageName: "exhibition.dummy", placeName: "지스타 2025", category: "전시관", closedInfo: "행사 종료", hoursInfo: "10:00 - 18:00", missionInfo: "스탬프 미션 완료")
    ]
}
