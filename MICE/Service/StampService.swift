//
// StampService.swift
// MICE
//
// Created by 이돈혁 on 8/28/25.
//
import Foundation
import Supabase
import UIKit

// MARK: - Stamp 구조체 (stamp 테이블)
struct Stamp: Codable, Identifiable {
    var id: String { contentid }
    let contentid: String
    let addr: String
    let createdtime: String?
    let image: String?
    let mapx: String?
    let mapy: String?
    let tel: String?
    let title: String?
    let homepage: String?
    let overview: String?
    let stampno: Int?
    let stampimg: String?
    let hours: String?
    let isAcquired: Bool
    let acquiredAt: Date?
    var isBookmarked: Bool
    func getTint() -> UIColor {
        if let stampno = stampno {
            if isAcquired {
                switch stampno {
                case 1...79:
                    return UIColor(red: 11/255, green: 160/255, blue: 172/255, alpha: 1)//박물관
                case 80...128:
                    return UIColor(red: 247/255, green: 106/255, blue: 1/255, alpha: 1)//미술관
                case 129...153:
                    return UIColor(red: 101/255, green: 0/255, blue: 0/255, alpha: 1)//기념관
                case 154...176:
                    return UIColor(red: 0/255, green: 2/255, blue: 105/255, alpha: 1)//전시관
                default:
                    return UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)//그 외
                }
            } else {
                return UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)
            }
        }
        return .clear
    }
}
struct MyStampRow: Decodable {
    let user_id: UUID
    let acquired_at: Date?
}
struct WishRow: Decodable {
    let user_id: UUID
}
struct StampRow: Decodable {
    var id: String { contentid }
    let contentid: String
    let addr: String
    let createdtime: String?
    let image: String?
    let mapx: String?
    let mapy: String?
    let tel: String?
    let title: String?
    let homepage: String?
    let overview: String?
    let stampno: Int?
    let stampimg: String?
    let hours: String?
    // LEFT JOIN으로 들어오는 중첩 결과 (사용자 본인 것만)
    let mystamp: [MyStampRow]?
    let wishlist: [WishRow]?
    // 편의 계산 프로퍼티
    var isAcquired: Bool { !(mystamp?.isEmpty ?? true) }
    var acquiredAt: Date? { mystamp?.first?.acquired_at }
    var isBookmarked: Bool { !(wishlist?.isEmpty ?? true) }
}
// MARK: - MyStamp 구조체 (mystamp 테이블)
struct MyStamp: Codable, Identifiable {
    let id: String
    let contentid: String
    let acquired_at: String
    let user_id: String
}
// MARK: - Wishlist 구조체 (stamp 테이블)
struct Wishlist: Codable, Identifiable {
    let id: String
    let contentid: String
    let user_id: String
}
class StampService {
    static let shared = StampService()
    private let client = SupabaseManager.shared.supabase
    private init() {
    }
    // MARK: - 전체 스탬프 목록 조회 (stamp 테이블)
    func getAllStamps() async throws -> [Stamp] {
        let rows: [StampRow] = try await client
            .from("stamp")
            .select("""
         *,
         mystamp:mystamp!left(user_id, acquired_at),
         wishlist:wishlist!left(user_id)
       """)
            .execute()
            .value
        return rows.map {
            Stamp(
                contentid: $0.contentid,
                addr: $0.addr,
                createdtime: $0.createdtime,
                image: $0.image,
                mapx: $0.mapx,
                mapy: $0.mapy,
                tel: $0.tel,
                title: $0.title,
                homepage: $0.homepage,
                overview: $0.overview,
                stampno: $0.stampno,
                stampimg: $0.stampimg,
                hours: $0.hours,
                isAcquired: $0.isAcquired,
                acquiredAt: $0.acquiredAt,
                isBookmarked: $0.isBookmarked
            )
        }
    }
    // MARK: - 특정 사용자가 획득한 스탬프 조회 (mystamp 테이블)
    func getMyStamps() async throws -> [MyStamp] {
        let response: [MyStamp] = try await client
            .from("mystamp")
            .select()
            .execute()
            .value
        return response
    }
    //MARK: - 특정 사용자가 특정 버튼을 누르면 mystamp 테이블에 기록됨
    func addMyStamp(contentId: String) async throws {
        do {
            try await client
                .from("mystamp")
                .insert(["contentid": contentId])
                .execute()
            print("mystamp insert 성공: \(contentId)")
        } catch {
            print("mystamp insert 에러:", error)   // 디버깅 로그
            throw error
        }
    }
    // MARK: - 특정 사용자의 위시리스트 조회 (wishlist 테이블)
    func getWishlist() async throws -> [Wishlist] {
        let response: [Wishlist] = try await client
            .from("wishlist")
            .select()
            .execute()
            .value
        return response
    }
    //MARK: - 사용자가 스크랩 버튼을 누르면 wishlist 테이블에 기록됨
    func addWishlist(contentId: String) async throws {
        try await client
            .from("wishlist")
            .insert(["contentid": contentId])
            .execute()
    }
    // MARK: - 사용자가 스크랩한 상태에서 스크랩 버튼을 누르면 whishlish 테이블에 삭제됨
    func deleteWishlist(contentId: String) async throws {
        try await client
            .from("wishlist")
            .delete()
            .eq("contentid", value: contentId)
            .execute()
    }
}

