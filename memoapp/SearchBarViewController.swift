//
//  SearchBarViewController.swift
//  memoapp
//
//  Created by 内藤有紀 on 2022/06/08.
//

import UIKit
import RealmSwift

class SearchBarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {    
    //セグメントのアウトレット
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var ltsearch: UILabel!
    @IBOutlet weak var ldsearch: UILabel!
    @IBOutlet weak var lcsearch: UILabel!
    @IBOutlet weak var tfsearch: UITextField!
    @IBOutlet weak var dpvdate: UIDatePicker!
    @IBOutlet weak var pvcname: UIPickerView!
    @IBOutlet weak var search: UIButton!
    let realm = try! Realm()  // ←追加
    var customerArray = try! Realm().objects(Customer.self).sorted(byKeyPath: "name", ascending: true)
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        print("テスト")
        pvcname.delegate = self
        pvcname.dataSource = self
        ltsearch.isHidden = false
        ldsearch.isHidden = true
        tfsearch.isHidden = false
        dpvdate.isHidden = true
        search.isHidden = false
        lcsearch.isHidden = true
        pvcname.isHidden = true
        print(customerArray[0].name)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    // 追加する
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pvcname.selectRow(1, inComponent: 0, animated: false)
    }

    // 追加する
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pvcname.selectRow(1, inComponent: 0, animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    /*
     pickerに表示する値を返すデリゲートメソッド.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(customerArray[row])
        return customerArray[row].name as? String
    }

    /*
     pickerに表示する行数を返すデータソースメソッド.
     (実装必須)
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return customerArray.count
    }
    
    /*
     pickerが選択された際に呼ばれるデリゲートメソッド.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
/*        print("value: \(customers[row])")*/
    }

    @IBAction func segmentChanged(sender: AnyObject) {
        //セグメントが変更されたときの処理
        //選択されているセグメントのインデックス
        selectedIndex = segmentedControl.selectedSegmentIndex
        print("\(selectedIndex)が選択されました。")
        if(selectedIndex == 0){
            ltsearch.isHidden = false
            tfsearch.isHidden = false
            search.isHidden = false
            ldsearch.isHidden = true
            dpvdate.isHidden = true
            lcsearch.isHidden = true
            pvcname.isHidden = true
        }else if(selectedIndex == 1){
            ltsearch.isHidden = true
            tfsearch.isHidden = true
            search.isHidden = false
            ldsearch.isHidden = false
            dpvdate.isHidden = false
            lcsearch.isHidden = true
            pvcname.isHidden = true
        }else if(selectedIndex == 2){
            lcsearch.isHidden = false
            pvcname.isHidden = false
            search.isHidden = false
            ltsearch.isHidden = true
            tfsearch.isHidden = true
            ldsearch.isHidden = true
            dpvdate.isHidden = true
        }
        //選択されたインデックスの文字列を取得してラベルに設定
        //label.text = segmentedControl.titleForSegmentAtIndex(selectedIndex)
    }

    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let nextViewController:ViewController = segue.destination as! ViewController
        print("テスト")
        if(selectedIndex == 0){
            if(tfsearch.text != ""){
                if let tfsearch = tfsearch.text {
                    let query_category = "title CONTAINS %@," + tfsearch
                    let memoArray = realm.objects(Memo.self).filter("title CONTAINS '" + tfsearch + "'")
                    print("Memo: \(memoArray)")
                    nextViewController.memoArray = memoArray
                }
            }
        }else if(selectedIndex == 1){
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var date = formatter.string(from: dpvdate.date)
            let query_category = "dateStr = %@"
            let memoArray = realm.objects(Memo.self).filter(query_category, date)
            let nextViewController:ViewController = segue.destination as! ViewController
            nextViewController.memoArray = memoArray
        }else if(selectedIndex == 2){
            let nextViewController:ViewController = segue.destination as! ViewController
            let counter = pvcname.selectedRow(inComponent: 0)
            let customer = customerArray[counter]
            let query_category = "customer.name = '\(customer.name)'"
            let memoArray = realm.objects(Memo.self).filter(query_category)
            print("Memo: \(memoArray)")
            nextViewController.memoArray = memoArray
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
