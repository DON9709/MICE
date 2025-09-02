//
//  BookmarkViewModel.swift
//  MICE
//
//  Created by 송명균 on 8/28/25.
//

import Foundation

// 임시 데이터를 위한 ViewModel
class BookmarkViewModel {
    
    // 임시 '저장한 스탬프' 데이터 (Stamp 타입)
    let savedStamps: [Stamp] = [
        Stamp(contentid: "saved_1", addr: "서울시 종로구", createdtime: nil, image: nil, mapx: nil, mapy: nil, tel: nil, title: "저장한 국립고궁박물관", homepage: nil, overview: nil, stampno: 8, stampimg: nil),
        Stamp(contentid: "saved_2", addr: "서울시 용산구", createdtime: nil, image: nil, mapx: nil, mapy: nil, tel: nil, title: "저장한 국립중앙박물관", homepage: nil, overview: nil, stampno: 11, stampimg: nil)
    ]
    
    // 임시 '다녀온 스탬프' 데이터 (Stamp 타입)
    let visitedStamps: [Stamp] = [
        Stamp(contentid: "visited_1", addr: "경기도 과천시", createdtime: nil, image: nil, mapx: nil, mapy: nil, tel: nil, title: "다녀온 국립현대미술관", homepage: nil, overview: nil, stampno: 86, stampimg: nil)
    ]
}
