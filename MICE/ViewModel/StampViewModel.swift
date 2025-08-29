//
//  StampViewModel.swift
//  MICE
//
//  Created by 장은새 on 8/25/25.
//

import UIKit
import Combine

class StampViewModel {

    // 선택된 카테고리 상태
    @Published var selectedCategory: String = "박물관"

    // 카테고리 구성
    lazy var items: [UIAction] = {
        let categories = ["박물관", "미술관", "전시관", "기념관"]
        return categories.map { category in
            UIAction(title: category) { [weak self] _ in
                self?.selectedCategory = category
            }
        }
    }()
}
