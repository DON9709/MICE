//
//  StampService.swift
//  MICE
//
//  Created by 이돈혁 on 8/28/25.
//

import Foundation
import Supabase

// MARK: - Stamp 구조체 (stamp 테이블)
struct Stamp: Codable, Identifiable {
    var id: String { contentid }
    let contentid: String
    let addr: String
    let createdtime: String
    let image: String
    let mapx: String
    let mapy: String
    let tel: String
    let title: String
    let homepage: String
    let overview: String
    let stampno: Int
    let stampimg: String
}

// MARK: - MyStamp 구조체 (mystamp 테이블)
struct MyStamp: Codable, Identifiable {
    let id: String
    let contentid: String
    let acquired_at: String
    let apple_uid: String
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
    func getMyStamps(appleUid: String) async throws -> [MyStamp] {
        let response: [MyStamp] = try await client
            .from("mystamp")
            .select()
            .eq("apple_uid", value: appleUid)
            .execute()
            .value
        return response
    }
    
    //MARK: - 특정 사용자가 특정 버튼을 누르면 mystamp 테이블에 기록됨
    func addMyStamp(appleUid: String, contentId: String) async throws {
        try await client
            .from("mystamp")
            .insert(["apple_uid": appleUid, "contentid": contentId])
            .execute()
    }

//  // MARK: - 전체 위시리스트 목록 조회 (stamp 테이블)
//    func getAllStamps() async throws -> [Stamp] {
//        let response: [Stamp] = try await client
//            .from("stamp")
//            .select()
//            .execute()
//            .value
//        return response
//    }
//
//    // MARK: - 특정 사용자의 위시리스트 조회 (mystamp 테이블)
//    func getMyStamps(appleUid: String) async throws -> [MyStamp] {
//        let response: [MyStamp] = try await client
//            .from("mystamp")
//            .select()
//            .eq("apple_uid", value: appleUid)
//            .execute()
//            .value
//        return response
//    }
//
//    //MARK: - 특정 사용자가 특정 버튼을 누르면 wishlist 테이블에 기록됨
//    func addMyStamp(appleUid: String, contentId: String) async throws {
//        try await client
//            .from("mystamp")
//            .insert(["apple_uid": appleUid, "contentid": contentId])
//            .execute()
//    }
}

