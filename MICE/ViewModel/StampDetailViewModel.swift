//
//  StampDetailViewModel.swift
//  MICE
//
//  Created by 장은새 on 8/26/25.
//

import CoreLocation
import Supabase

class StampDetailViewModel {
    private let unlockDistance: Double = 400.0 // 기준 거리
    private var targetStamp: Stamp?

    enum UnlockResult {
        case success(Date)
        case tooFar
        case failed
    }

    func setStamp(_ stamp: Stamp) {
        self.targetStamp = stamp
    }

    // 현재 위치와 스탬프 위치를 비교해서 가까우면 true 리턴
    func canUnlockStamp() async -> Bool {
        guard let stamp = targetStamp,
              let mapy = stamp.mapy,
              let mapx = stamp.mapx,
              let lat = Double(mapy),
              let lon = Double(mapx) else {
            return false
        }
        do {
            let userLocation = try await LocationManager.shared.getCurrentLocation()
            let target = CLLocation(latitude: lat, longitude: lon)
            let distance = userLocation.distance(from: target)
            print("현재 위치와 스탬프 간 거리: \(distance)m")
            return distance <= unlockDistance
        } catch {
            print("위치 가져오기 실패: \(error)")
            return false
        }
    }

    func tryUnlockStamp() async -> UnlockResult {
        let isClose = await canUnlockStamp()
        guard isClose else { return .tooFar }
        guard let contentId = targetStamp?.contentid else { return .failed }
        do {
            try await StampService.shared.addMyStamp(contentId: contentId)
            return .success(Date())
        } catch {
            print("addMyStamp 실패:", error)   // 디버깅 로그
            return .failed
        }
    }
}
