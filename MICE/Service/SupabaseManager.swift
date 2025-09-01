//
//  SupabaseManager.swift
//  MICE
//
//  Created by 이돈혁 on 8/20/25.
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
        let dict = Bundle.parsePlist(ofName: "SecureAPIKeys")
        let value = dict["SUPABASE_ANON_KEY"] as! String
        let value2 = dict["SUPABASE_URL"] as! String
        let supabaseUrl = URL(string: value2)!
        let supabaseKey = value
        self.supabase = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: supabaseKey)
    }

    func registerOrUpdateUser(appleUID: String, name: String?, email: String?, provider: String) {
        let client = supabase

        Task {
            do {
                guard let supabaseUID = client.auth.currentUser?.id else {
                    print("Supabase 인증된 사용자 ID 없음")
                    return
                }

                let existingUsers = try await client
                    .from("users")
                    .select()
                    .eq("apple_uid", value: appleUID)
                    .execute()
                    .value as? [[String: Any]]

                if let existing = existingUsers?.first {
                    print("기존 사용자 발견. 업데이트 진행")

                    try await client
                        .from("users")
                        .update([
                            "name": name ?? "",
                            "email": email ?? ""
                        ])
                        .eq("apple_uid", value: appleUID)
                        .execute()
                } else {
                    print("새로운 사용자. 등록 진행")

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
                print("Supabase 사용자 등록/업데이트 실패: \(error)")
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
                print("사용자 없음 또는 응답 파싱 실패")
                return
            }

            print("사용자 프로필: \(userData)")
        } catch {
            print("사용자 프로필 조회 실패: \(error)")
        }
    }
    
    func fetchEmail(for appleUID: String) async -> String? {
        do {
            let response = try await supabase
                .from("users")
                .select("email")
                .eq("apple_uid", value: appleUID)
                .limit(1)
                .execute()
            
            guard let users = response.value as? [[String: Any]],
                  let userData = users.first,
                  let email = userData["email"] as? String else {
                print("이메일 조회 실패 또는 형식 오류")
                return nil
            }

            return email
        } catch {
            print("이메일 조회 중 오류 발생: \(error)")
            return nil
        }
    }
}


extension Bundle {

    static func parsePlist(ofName name: String) -> [String: AnyObject] {
        guard let plistUrl = Bundle.main.url(forResource: name, withExtension: "plist") else {
            fatalError("Couldn't find file '\(name).plist'.")
        }
        
        guard let plistData = try? Data(contentsOf: plistUrl),
              let dict = try? PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: AnyObject] else {
            fatalError("Couldn't load dictionary from data.")
        }
        
        return dict
    }
}



    
