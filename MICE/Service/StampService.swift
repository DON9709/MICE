//
// StampService.swift
// MICE
//
// Created by 이돈혁 on 8/28/25.
//
import Foundation
import Supabase
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
}
// MARK: - MyStamp 구조체 (mystamp 테이블)
struct MyStamp: Codable, Identifiable {
    let id: String
    let contentid: String
    let acquired_at: String
    let user_id: String
}
// MARK: - Stamp 구조체 (stamp 테이블)
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
        let response: [Stamp] = try await client
            .from("stamp")
            .select()
            .execute()
            .value
        return response
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
    func addMyStamp(appleUid: String, contentId: String) async throws {
        try await client
            .from("mystamp")
            .insert(["contentid": contentId])
            .execute()
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
