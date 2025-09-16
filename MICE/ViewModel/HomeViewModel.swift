//
//  HomeViewModel.swift
//  MICE
//
//  Created by 송명균 on 8/25/25.
//

import Foundation
import Combine
import CoreLocation

@MainActor
class HomeViewModel {
    
    // MARK: - Published Properties
    @Published var achievedStampCount: Int = 0
    @Published var unachievedStampCount: Int = 0
    @Published var recentlyAcquiredStamps: [Stamp] = []
    @Published var nearbyStamps: [Stamp] = []
    @Published var hotStamps: [Stamp] = []
    
    private var allStamps: [Stamp] = []

    // MARK: - Titles
    let mainTitle = "MICE"
    let stampSectionTitle = "수집한 스탬프"
    let nearbySectionTitle = "주변 문화 전시 공간"
    let hotSectionTitle = "🔥 지금 핫한 전시 공간"
    
    // MARK: - Data Fetching and Processing
    func fetchAllHomeData() async {
        do {
            self.allStamps = try await StampService.shared.getAllStamps()
            
            processAcquiredStamps()
            processHotStamps()
            await processNearbyStamps()
            
        } catch {
            print("Error fetching home data: \(error)")
        }
    }
    
  
    private func processAcquiredStamps() {
        // 1. 전체 스탬프 중 isAcquired가 true인 것만 필터링
        let acquired = allStamps.filter { $0.isAcquired }
        
        // 2. 획득/미획득 개수 업데이트
        self.achievedStampCount = acquired.count
        self.unachievedStampCount = allStamps.count - acquired.count
        
        // 3. 획득한 스탬프를 최신순으로 정렬하여 최대 10개까지만 recentlyAcquiredStamps에 저장
        self.recentlyAcquiredStamps = acquired
            .sorted { $0.acquiredAt ?? .distantPast > $1.acquiredAt ?? .distantPast }
            .prefix(10)
            .map { $0 }
    }
    
    private func processHotStamps() {
        let sortedByDate = allStamps.sorted {
            let date1 = DateFormatter.iso8601.date(from: $0.createdtime ?? "") ?? .distantPast
            let date2 = DateFormatter.iso8601.date(from: $1.createdtime ?? "") ?? .distantPast
            return date1 > date2
        }
        self.hotStamps = Array(sortedByDate.prefix(10))
    }

    private func processNearbyStamps() async {
        do {
            let userLocation = try await LocationManager.shared.getCurrentLocation()
            
            let sortedByDistance = allStamps.sorted {
                let stampLocation1 = CLLocation(latitude: Double($0.mapy ?? "0") ?? 0, longitude: Double($0.mapx ?? "0") ?? 0)
                let stampLocation2 = CLLocation(latitude: Double($1.mapy ?? "0") ?? 0, longitude: Double($1.mapx ?? "0") ?? 0)
                
                guard stampLocation1.coordinate.isValid, stampLocation2.coordinate.isValid else { return false }
                
                let distance1 = userLocation.distance(from: stampLocation1)
                let distance2 = userLocation.distance(from: stampLocation2)
                
                return distance1 < distance2
            }
            self.nearbyStamps = Array(sortedByDistance.prefix(10))
            
        } catch {
            print("Failed to get user location or sort by distance: \(error)")
            self.nearbyStamps = Array(allStamps.shuffled().prefix(10))
        }
    }
    
    func updateBookmarkStatus(contentId: String, isBookmarked: Bool) {
        if let index = allStamps.firstIndex(where: { $0.contentid == contentId }) {
            allStamps[index].isBookmarked = isBookmarked
        }
        if let index = nearbyStamps.firstIndex(where: { $0.contentid == contentId }) {
            nearbyStamps[index].isBookmarked = isBookmarked
        }
        if let index = hotStamps.firstIndex(where: { $0.contentid == contentId }) {
            hotStamps[index].isBookmarked = isBookmarked
        }
    }
}

// DateFormatter와 CLLocationCoordinate2D 확장은 그대로 유지
extension DateFormatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

extension CLLocationCoordinate2D {
    var isValid: Bool {
        return self.latitude != 0 && self.longitude != 0
    }
}


