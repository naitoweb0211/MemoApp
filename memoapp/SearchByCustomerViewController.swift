//
//  SearchByCustomerViewController.swift
//  memoapp
//
//  Created by 内藤有紀 on 2022/06/08.
//

import UIKit
import RealmSwift

class SearchByCustomerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var lsearch: UILabel!
    @IBOutlet weak var pvcname: UIPickerView!
    @IBOutlet weak var search: UIButton!
    let realm = try! Realm()  // ←追加
    var customerArray = try! Realm().objects(Customer.self).sorted(byKeyPath: "name", ascending: true)  // ←追加
    override func viewDidLoad() {
        super.viewDidLoad()
        pvcname.delegate = self
        pvcname.dataSource = self
        for customer in customerArray {
            print("顧客ID: \(customer.id)")
            print("顧客名: \(customer.name)")
        }
        print("テスト")
        // Do any additional setup after loading the view.
    }
 
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    // 追加する
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
     pickerに表示する行数を返すデータソースメソッド.
     (実装必須)
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return customerArray.count
    }

    /*
     pickerに表示する値を返すデリゲートメソッド.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(customerArray[row])
        return customerArray[row].name as? String
    }
    
    /*
     pickerが選択された際に呼ばれるデリゲートメソッド.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
/*        print("value: \(customers[row])")*/
    }
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        print(customerArray)
        print("クリックされました")
        let nextViewController:ViewController = segue.destination as! ViewController
        let counter = pvcname.selectedRow(inComponent: 0)
        let customer = customerArray[counter]
        let query_category = "customer.name = '\(customer.name)'"
        let memoArray = realm.objects(Memo.self).filter(query_category)
        print("Memo: \(memoArray)")
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
