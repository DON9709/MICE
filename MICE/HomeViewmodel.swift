//
//  HomeViewmodel.swift
//  MICE
//
//  Created by 송명균 on 8/25/25.
//

import Foundation

class HomeViewModel {
    
    // View가 구독(observing)할 수 있도록 데이터를 준비합니다.
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
            Stamp(imageName: "stamp.dummy"),
            Stamp(imageName: "stamp.dummy"),
            Stamp(imageName: "stamp.dummy")
        ]
        
        self.nearbyExhibitions = [
            Exhibition(imageName: "exhibition.dummy", title: "서울 모빌리티쇼", date: "2025/08/18"),
            Exhibition(imageName: "exhibition.dummy", title: "아트 부산 2025", date: "2025/09/12"),
            Exhibition(imageName: "exhibition.dummy", title: "디자인 페스타", date: "2025/10/01"),
            Exhibition(imageName: "exhibition.dummy", title: "건축 문화제", date: "2025/10/15"),
            Exhibition(imageName: "exhibition.dummy", title: "K-핸드메이드페어", date: "2025/11/01"),
            Exhibition(imageName: "exhibition.dummy", title: "서울디자인페스티벌", date: "2025/11/20"),
            Exhibition(imageName: "exhibition.dummy", title: "공예 트렌드페어", date: "2025/12/05"),
            Exhibition(imageName: "exhibition.dummy", title: "홈테이블데코페어", date: "2025/12/10"),
            Exhibition(imageName: "exhibition.dummy", title: "서울일러스트레이션페어", date: "2025/12/18"),
            Exhibition(imageName: "exhibition.dummy", title: "코믹월드", date: "2025/12/25")
        ]
        
        self.hotExhibitions = [
            Exhibition(imageName: "exhibition.dummy", title: "일러스트레이션 페어", date: "2025/08/22", isBookmarked: true),
            Exhibition(imageName: "exhibition.dummy", title: "서울 국제 도서전", date: "2025/09/05"),
            Exhibition(imageName: "exhibition.dummy", title: "핸드메이드 페어", date: "2025/11/20"),
            Exhibition(imageName: "exhibition.dummy", title: "카페쇼", date: "2025/11/08"),
            Exhibition(imageName: "exhibition.dummy", title: "지스타 2025", date: "2025/11/14"),
            Exhibition(imageName: "exhibition.dummy", title: "어반브레이크", date: "2025/08/30"),
            Exhibition(imageName: "exhibition.dummy", title: "프리즈 서울", date: "2025/09/01"),
            Exhibition(imageName: "exhibition.dummy", title: "키아프", date: "2025/09/03"),
            Exhibition(imageName: "exhibition.dummy", title: "플레이엑스포", date: "2025/10/11"),
            Exhibition(imageName: "exhibition.dummy", title: "AGF KOREA", date: "2025/12/03", isBookmarked: true)
        ]
    }
}
