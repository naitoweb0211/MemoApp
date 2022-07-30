//
//  Customer.swift
//  memoapp
//
//  Created by 内藤有紀 on 2022/06/06.
//

import RealmSwift

class Customer: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0

    // タイトル
    @objc dynamic var name = ""
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
