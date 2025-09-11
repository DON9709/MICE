//
//  StampImageDataManager.swift
//  MICE
//
//  Created by 장은새 on 9/9/25.
//

import UIKit

class StampImageDataManager {
    static let shared = StampImageDataManager()
    func getAcquiredFirstStampImageUrl() async -> Stamp? {
        guard let stamps = try? await StampService.shared.getAllStamps() else { return nil }
        let acquiredStamps = stamps.filter { $0.isAcquired == true }
        let acquiredStampsOrdered = acquiredStamps.sorted { $0.acquiredAt ?? Date() > $1.acquiredAt ?? Date() }//Date() 기본값으로 현재시간을 넣음.
        return acquiredStampsOrdered.first
    }
    func getAcquiredSecondStampImageUrl() async -> Stamp? {
        guard let stamps = try? await StampService.shared.getAllStamps() else { return nil }
        let acquiredStamps = stamps.filter { $0.isAcquired == true }
        let acquiredStampsOrdered = acquiredStamps.sorted { $0.acquiredAt ?? Date() > $1.acquiredAt ?? Date() }//Date() 기본값으로 현재시간을 넣음.
        return acquiredStampsOrdered.count > 1 ? acquiredStampsOrdered[1] : nil
    }
    func getAcquiredThirdStampImageUrl() async -> Stamp? {
        guard let stamps = try? await StampService.shared.getAllStamps() else { return nil }
        let acquiredStamps = stamps.filter { $0.isAcquired == true }
        let acquiredStampsOrdered = acquiredStamps.sorted { $0.acquiredAt ?? Date() > $1.acquiredAt ?? Date() }//Date() 기본값으로 현재시간을 넣음.
        return acquiredStampsOrdered.count > 2 ? acquiredStampsOrdered[2] : nil
    }
    private init() {}
}
