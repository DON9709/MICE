//
//  HomeViewmodel.swift
//  MICE
//
//  Created by 송명균 on 8/25/25.
//

import Foundation

// 스탬프 예시 데이터를 위한 모델
struct StampExample {
    let imageName: String
    let title: String
    let date: String
}

class HomeViewModel {
    
    // MARK: - Properties
    
    let mainTitle = "MICE"
    let stampSectionTitle = "수집한 스탬프"
    let nearbySectionTitle = "주변 문화 전시 공간"
    let hotSectionTitle = "🔥 지금 핫한 전시 공간"
    
    // 스탬프 현황 데이터
    let achievedStampCount = 5
    let unachievedStampCount = 175
    
    // 스탬프 예시 데이터
    let stampExamples: [StampExample]
    
    // 기존 데이터 (이하 동일)
    let nearbyExhibitions: [Exhibition]
    let hotExhibitions: [Exhibition]
    let stamps: [Stamp] // This is no longer used in the UI but we'll keep it for now

    init() {
        // --- 더미 데이터 생성 ---
        self.stampExamples = [
            StampExample(imageName: "stamp_bulguksa", title: "불국사", date: "Jul 15 2018"),
            StampExample(imageName: "stamp_museum", title: "국립 중앙 박물관", date: "Jul 15 2018"),
            StampExample(imageName: "stamp_gyeongbokgung", title: "경복궁", date: "Jul 15 2018"),
            StampExample(imageName: "stamp_namsan", title: "남산 타워", date: "Jul 15 2018")
        ]
        
        // This data is still needed for the other sections
        self.stamps = [] // No longer needed for UI
        self.nearbyExhibitions = [
            Exhibition(imageName: "exhibition.dummy", title: "서울 모빌리티쇼", date: "2025/08/18"),
            Exhibition(imageName: "exhibition.dummy", title: "아트 부산 2025", date: "2025/09/12"),
        ]
        
        self.hotExhibitions = [
            Exhibition(imageName: "exhibition.dummy", title: "일러스트레이션 페어", date: "2025/08/22", isBookmarked: true),
            Exhibition(imageName: "exhibition.dummy", title: "서울 국제 도서전", date: "2025/09/05"),
        ]
    }
}
