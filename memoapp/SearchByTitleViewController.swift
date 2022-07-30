//
//  SearchByTitleViewController.swift
//  memoapp
//
//  Created by 内藤有紀 on 2022/06/08.
//

import UIKit
import RealmSwift
class SearchByTitleViewController: UIViewController {
    @IBOutlet weak var lsearch: UILabel!
    @IBOutlet weak var tfsearch: UITextField!
    @IBOutlet weak var search: UIButton!
    let realm = try! Realm()  // ←追加
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let nextViewController:ViewController = segue.destination as! ViewController
        if(tfsearch.text != ""){
            if let tfsearch = tfsearch.text {
                let query_category = "title = '" + tfsearch + "'"
                let memoArray = realm.objects(Memo.self).filter(query_category)
                print("Memo: \(memoArray)")
                nextViewController.memoArray = memoArray
            }
        }
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
