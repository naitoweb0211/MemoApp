//
//  ViewController.swift
//  memoapp
//
//  Created by 内藤有紀 on 2022/06/03.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search: UISearchBar!
    let realm = try! Realm()  // ←追加
    @IBOutlet weak var ltitle: UILabel!
    @IBOutlet weak var ldate: UILabel!
    @IBOutlet weak var lcustomer: UILabel!

    // DB内のタスクが格納されるリスト。
    // 日付の近い順でソート：昇順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var memoArray = try! Realm().objects(Memo.self).sorted(byKeyPath: "id", ascending: true)  // ←追加
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.fillerRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        search.delegate = self //　追記
        print("最初の画面")
    }

    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoArray.count
    }

    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
        tableView.rowHeight = 100
        // Cellに値を設定する  --- ここから ---
        let memo = memoArray[indexPath.row]
        //cell.textLabel?.text = memo.title
        let ltitle = cell.viewWithTag(1) as! UILabel
        ltitle.text = memo.title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var dateString:String = ""
        if(memo.date != nil){
            dateString = formatter.string(from: memo.date!)
        }
        //cell.detailTextLabel?.text = dateString
        let ldate = cell.viewWithTag(2) as! UILabel
        ldate.text = dateString
        let lcustomer = cell.viewWithTag(3) as! UILabel
        lcustomer.text = memo.customer.name
        
        // --- ここまで追加 ---
        return cell
    }

    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil) 
    }

    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // --- ここから ---
        if editingStyle == .delete {
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.memoArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } // --- ここまで追加 ---
    }

    func setupSearchBar(){
        search.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.performSegue(withIdentifier: "searchSegue", sender: nil)
            guard let searchText = searchBar.text else {
                return false
            }
            print(searchText)  //SeachBarに入力された文字列が出力されるはず
            return false
    }
    
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){

        if segue.identifier == "cellSegue" {
            let memoViewController:MemoViewController = segue.destination as! MemoViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            memoViewController.memo = memoArray[indexPath!.row]
            print(memoViewController.memo.customer)
        } else {
            if segue.identifier == "searchSegue" {
                let serchBarViewController:SearchBarViewController = segue.destination as! SearchBarViewController
            }else{
                let memoViewController:MemoViewController = segue.destination as! MemoViewController
                let indexPath = self.tableView.indexPathForSelectedRow
                let memo = Memo()

                let allMemos = realm.objects(Memo.self)
                if allMemos.count != 0 {
                    memo.id = allMemos.max(ofProperty: "id")! + 1
                }
                memoViewController.memo = memo
            }
        }
    }
}

