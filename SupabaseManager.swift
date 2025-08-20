//
//  SupabaseManager.swift
//  Heatmap
//
//  Created by 이돈혁 on 7/4/25.
//

import Foundation
import Supabase

struct User: Encodable {
    // The 'id' field stores UUID strings representing unique user identifiers.
    let id: UUID
    let name: String
    let email: String
    let provider: String
    let created_at: String
}

class SupabaseManager {
    static let shared = SupabaseManager()

    let supabase: SupabaseClient

    private init() {
        let supabaseUrl = URL(string: "https://tapgtggjidgehsftsfuk.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRhcGd0Z2dqaWRnZWhzZnRzZnVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE1MjQzMTgsImV4cCI6MjA2NzEwMDMxOH0.YiqWLbBVbvz1hi856YLsxg-WuKTRv9X4GyHwPOk6iDk"

        self.supabase = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: supabaseKey)
    }

    func registerOrUpdateUser(appleUID: String, name: String?, email: String?, provider: String) {
        let client = supabase

        Task {
            do {
                guard let supabaseUID = client.auth.currentUser?.id else {
                    print("❌ Supabase 인증된 사용자 ID 없음")
                    return
                }

                let existingUsers = try await client
                    .from("users")
                    .select()
                    .eq("apple_uid", value: appleUID)
                    .execute()
                    .value as? [[String: Any]]

                if let existing = existingUsers?.first {
                    print("🟢 기존 사용자 발견. 업데이트 진행")

                    try await client
                        .from("users")
                        .update([
                            "name": name ?? "",
                            "email": email ?? ""
                        ])
                        .eq("apple_uid", value: appleUID)
                        .execute()
                } else {
                    print("🆕 새로운 사용자. 등록 진행")

                    try await client
                        .from("users")
                        .insert([
                            "apple_uid": appleUID,
                            "name": name ?? "",
                            "email": email ?? "",
                            "provider": provider
                        ])
                        .execute()
                }
            } catch {
                print("❌ Supabase 사용자 등록/업데이트 실패: \(error)")
            }
        }
    }
    
    var client: SupabaseClient {
        return supabase
    }

    func fetchUserProfile(userID: String) async {
        do {
            let response = try await supabase
                .from("users")
                .select()
                .eq("apple_uid", value: userID)
                .limit(1)
                .execute()
            
            guard let users = response.value as? [[String: Any]],
                  let userData = users.first else {
                print("❌ 사용자 없음 또는 응답 파싱 실패")
                return
            }

            print("사용자 프로필: \(userData)")
        } catch {
            print("❌ 사용자 프로필 조회 실패: \(error)")
        }
    }
}
