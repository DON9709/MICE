//
//  BookmarkViewModel.swift
//  MICE
//
//  Created by 송명균 on 8/28/25.
//

import Foundation
import Combine

enum BookmarkCategoryType: Int {
    case all, museum, exhibition, artGallery, memorial
}

@MainActor
class BookmarkViewModel {
    
    // MARK: - Published Properties
    @Published var filteredStamps: [Stamp] = []
    
    // MARK: - Private Properties
    private var allBookmarkedStamps: [Stamp] = []
    private var allDownloadedStamps: [Stamp] = [] // '다녀온 스탬프'를 위한 데이터
    
    // MARK: - State Properties
    var currentFilterType: FilterType = .bookmarked { didSet { applyFilters() } }
    var currentCategoryFilter: BookmarkCategoryType = .all { didSet { applyFilters() } }
    
    enum FilterType {
        case bookmarked, downloaded
    }

    // MARK: - Data Fetching
    func fetchBookmarkedStamps() async {
        do {
            // 1. 내가 찜한 목록(Wishlist)을 가져옵니다. (contentId 목록)
            async let wishlist = StampService.shared.getWishlist()
            // 2. 모든 스탬프 정보를 가져옵니다.
            async let allStamps = StampService.shared.getAllStamps()
            
            // 3. 찜한 contentId들을 Set으로 만들어 빠른 조회를 가능하게 합니다.
            let wishlistedIds = try await Set(wishlist.map { $0.contentid })
            self.allBookmarkedStamps = try await allStamps.filter { wishlistedIds.contains($0.contentid) }
            
            // '다녀온 스탬프' 데이터도 미리 준비
            self.allDownloadedStamps = try await allStamps.filter { $0.isAcquired }
            
            // 데이터를 가져온 후 현재 필터를 적용
            applyFilters()
            
        } catch {
            print("Error fetching bookmarked stamps: \(error)")
            self.allBookmarkedStamps = []
            self.allDownloadedStamps = []
            applyFilters()
        }
    }
    
    private func applyFilters() {
        let sourceStamps = (currentFilterType == .bookmarked) ? allBookmarkedStamps : allDownloadedStamps
        
        if currentCategoryFilter == .all {
            filteredStamps = sourceStamps
            return
        }
        
        let categoryRange: ClosedRange<Int>
        switch currentCategoryFilter {
        case .museum:
            categoryRange = 1...79
        case .exhibition:
            categoryRange = 154...177
        case .artGallery:
            categoryRange = 80...128
        case .memorial:
            categoryRange = 129...153
        default:
            filteredStamps = sourceStamps
            return
        }
        
        filteredStamps = sourceStamps.filter { categoryRange.contains($0.stampno ?? -1) }
    }
    
    // 북마크 화면에서 북마크 해제 시, 목록에서 즉시 제거하는 함수
    func updateBookmarkStatus(contentId: String, isBookmarked: Bool) {
        if !isBookmarked {
            allBookmarkedStamps.removeAll { $0.contentid == contentId }
            applyFilters() // 필터를 다시 적용하여 화면에 반영
        }
    }
}
