//
//  SearchModel.swift
//  MICE
//
//  Created by 송명균 on 8/26/25.
//

import Foundation

// 검색 결과 데이터 모델
struct SearchResult {
    let imageName: String
    let placeName: String
    let category: String 
    let closedInfo: String // 휴업일
    let hoursInfo: String // 영업시간
    let missionInfo: String // 스탬프 미션
}
