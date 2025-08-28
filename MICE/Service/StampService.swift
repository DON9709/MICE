//
//  StampService.swift
//  MICE
//
//  Created by 이돈혁 on 8/28/25.
//

//import Foundation
//import Supabase
//
//struct Stamp: Decodable {
//let id: String
//let contentid: String
//let userid: String
//let acquired_at: String
//}
//
//class StampService {
//private let client = SupabaseManager.shared.supabase
//
//// MARK: - 스탬프 추가
//func addStamp(userId: String, contentId: String) async throws {
//    let newStamp: [String: Any] = [
//        "id": UUID().uuidString,
//        "userid": userId,
//        "contentid": contentId,
//        "acquired_at": ISO8601DateFormatter().string(from: Date())
//    ]
//    
//    try await client
//        .from("mystamp")
//        .insert(values: newStamp)
//        .execute()
//}
//
//// MARK: - 특정 유저의 스탬프 전체 조회
//func getStampsByUser(userId: String) async throws -> [Stamp] {
//    let response = try await client
//        .from("mystamp")
//        .select()
//        .eq(column: "userid", value: userId)
//        .execute()
//    
//    return try response.decoded(to: [Stamp].self)
//}
//
//// MARK: - 특정 콘텐츠 스탬프 보유 여부 확인
//func hasStamp(userId: String, contentId: String) async throws -> Bool {
//    let response = try await client
//        .from("mystamp")
//        .select()
//        .eq(column: "userid", value: userId)
//        .eq(column: "contentid", value: contentId)
//        .limit(1)
//        .execute()
//    
//    let result = try response.decoded(to: [Stamp].self)
//    return !result.isEmpty
//}
//}
