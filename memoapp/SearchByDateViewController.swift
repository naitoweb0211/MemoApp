//
//  SearchByDateViewController.swift
//  memoapp
//
//  Created by 内藤有紀 on 2022/06/08.
//

import UIKit
import RealmSwift
class SearchByDateViewController: UIViewController {
    @IBOutlet weak var lsearch: UILabel!
    @IBOutlet weak var dpvdate: UIDatePicker!
    @IBOutlet weak var search: UIButton!
    var memoArray = try! Realm().objects(Memo.self).sorted(byKeyPath: "id", ascending: true)  // ←追加
    let realm = try! Realm()  // ←追加
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var date = formatter.string(from: dpvdate.date)
        let query_category = "dateStr = %@"
        let memoArray = realm.objects(Memo.self).filter(query_category, date)
        let nextViewController:ViewController = segue.destination as! ViewController
        nextViewController.memoArray = memoArray
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
