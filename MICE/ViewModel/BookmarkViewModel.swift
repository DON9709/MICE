//
//  BookmarkViewModel.swift
//  MICE
//
//  Created by 송명균 on 8/28/25.
//

//
//  BookmarkViewModel.swift
//  MICE
//
//  Created by 송명균 on 8/28/25.
//

import Foundation
import Combine

@MainActor
class BookmarkViewModel {
    @Published var savedStamps: [Stamp] = []
    
    let visitedStamps: [Stamp] = [
        Stamp(contentid: "visited_1", addr: "경기도 과천시", createdtime: nil, image: nil, mapx: nil, mapy: nil, tel: nil, title: "다녀온 국립현대미술관", homepage: nil, overview: nil, stampno: 86, stampimg: nil, isAcquired: true, acquiredAt: nil, isBookmarked: false)
    ]
    
    // ▼▼▼▼▼ 찜한 스탬프 목록을 가져오는 로직 ▼▼▼▼▼
    func fetchSavedStamps() async {
        do {
            // 1. 내가 찜한 목록(Wishlist)을 가져옵니다. (contentId 목록)
            async let wishlist = StampService.shared.getWishlist()
            // 2. 모든 스탬프 정보를 가져옵니다.
            async let allStamps = StampService.shared.getAllStamps()
            
            // 3. 찜한 contentId들을 Set으로 만들어 빠른 조회를 가능하게 합니다.
            let wishlistedIds = try await Set(wishlist.map { $0.contentid })
            
            // 4. 모든 스탬프 중에서, 찜한 id를 가진 스탬프만 필터링합니다.
            let filteredStamps = try await allStamps.filter { wishlistedIds.contains($0.contentid) }
            
            self.savedStamps = filteredStamps
            
        } catch {
            print("Error fetching wishlisted stamps: \(error)")
            self.savedStamps = []
        }
    }
}
