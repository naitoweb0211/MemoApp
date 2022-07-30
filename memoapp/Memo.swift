//
//  Memo.swift
//  memoapp
//
//  Created by 内藤有紀 on 2022/06/03.
//

import RealmSwift

class Memo: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0

    // タイトル
    @objc dynamic var title = ""

    // 内容
    @objc dynamic var contents = ""

    // 日時
    @objc dynamic var dateStr = "20180101"
    @objc dynamic var date:Date? {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: dateStr)
        }
        set {
            if let date = newValue {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                dateStr = formatter.string(from: date)
            }
        }
    }

    @objc dynamic var customer: Customer!
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
