//
//  HomeViewmodel.swift
//  MICE
//
//  Created by 송명균 on 8/25/25.
//

import Foundation

class HomeViewModel {
    
    // View가 구독(observing)할 수 있도록 데이터를 준비합니다.
    // 실제 앱에서는 이 데이터가 네트워크 통신 등을 통해 채워집니다.
    let stamps: [Stamp]
    let nearbyExhibitions: [Exhibition]
    let hotExhibitions: [Exhibition]
    
    // 제목 텍스트
    let mainTitle = "MICE"
    let stampSectionTitle = "수집한 스탬프"
    let nearbySectionTitle = "주변 문화 전시 공간"
    let hotSectionTitle = "🔥 지금 핫한 전시 공간"

    init() {
        // --- 더미 데이터 생성 ---
        self.stamps = [
            Stamp(imageName: "stamp.dummy"),
            Stamp(imageName: "stamp.dummy"),
            Stamp(imageName: "stamp.dummy"),
            Stamp(imageName: "stamp.dummy"),
            Stamp(imageName: "stamp.dummy")
        ]
        
        self.nearbyExhibitions = [
            Exhibition(imageName: "exhibition.dummy", title: "서울 모빌리티쇼", date: "2025/08/18"),
            Exhibition(imageName: "exhibition.dummy", title: "아트 부산 2025", date: "2025/09/12"),
            Exhibition(imageName: "exhibition.dummy", title: "디자인 페스타", date: "2025/10/01")
        ]
        
        self.hotExhibitions = [
            Exhibition(imageName: "exhibition.dummy", title: "일러스트레이션 페어", date: "2025/08/22", isBookmarked: true),
            Exhibition(imageName: "exhibition.dummy", title: "서울 국제 도서전", date: "2025/09/05"),
            Exhibition(imageName: "exhibition.dummy", title: "핸드메이드 페어", date: "2025/11/20")
        ]
    }
}
