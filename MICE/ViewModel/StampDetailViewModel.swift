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
    private var hasAcquired: Bool = false

    // VC가 구독할 콜백: 400m 이내 여부(true/false)
    var onProximityUpdate: ((Bool) -> Void)?

    // 지속 모니터링 제어용
    private var monitorTask: Task<Void, Never>?
    private let monitorIntervalNs: UInt64 = 2_000_000_000 // 2초 간격

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
            hasAcquired = true
            return .success(Date())
        } catch {
            print("addMyStamp 실패:", error)   // 디버깅 로그
            return .failed
        }
    }

    /// 상세 화면 진입 시 호출: 주기적으로 canUnlockStamp()를 확인하여 콜백으로 전달
    func startProximityMonitoring() {
        monitorTask?.cancel()
        monitorTask = Task { [weak self] in
            guard let self = self else { return }
            while !Task.isCancelled {
                if self.hasAcquired {
                    break
                }
                let can = await self.canUnlockStamp()
                await MainActor.run { self.onProximityUpdate?(can) }
                try? await Task.sleep(nanoseconds: self.monitorIntervalNs)
            }
        }
    }

    /// 상세 화면 이탈 시 호출: 모니터링 중단
    func stopProximityMonitoring() {
        monitorTask?.cancel()
        monitorTask = nil
    }
}
