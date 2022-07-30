//
//  InputViewController.swift
//  memoapp
//
//  Created by 内藤有紀 on 2022/06/03.
//

import UIKit
import RealmSwift
class MemoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var ltitle: UILabel!
    @IBOutlet weak var lcname: UILabel!
    @IBOutlet weak var ldate: UILabel!
    @IBOutlet weak var lmemo: UILabel!
    @IBOutlet weak var tftitle: UITextField!
    @IBOutlet weak var pvcname: UIPickerView!
    @IBOutlet weak var dpvdate: UIDatePicker!
    @IBOutlet weak var tvmemo: UITextView!
    @IBOutlet weak var addCustomer: UIButton!
    @IBOutlet weak var addMemo: UIButton!
    @IBOutlet weak var removeMemo: UIButton!
    @IBOutlet weak var removeCustomer: UIButton!
    var memo = Memo()
    private var customers = [""]
    var customerArray = try! Realm().objects(Customer.self).sorted(byKeyPath: "name", ascending: true)  // ←追加
    let realm = try! Realm()  // ←追加
    override func viewDidLoad() {
        for customer in customerArray {
            print("顧客ID: \(customer.id)")
            customers.append(customer.name)
        }
        super.viewDidLoad()
        addMemo.backgroundColor = UIColor.orange
        removeMemo.backgroundColor = UIColor.orange
        pvcname.delegate = self
        pvcname.dataSource = self
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        tftitle.text = self.memo.title
        print ("ID: \(self.memo.title)")
        if(self.memo.customer != nil){
            pvcname.selectRow(self.memo.customer.id, inComponent: 0, animated: false)
        }
        if(memo.date != nil) {
            dpvdate.date = memo.date!
        }
        tvmemo.text = self.memo.contents
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
        return customers.count
    }

    /*
     pickerに表示する値を返すデリゲートメソッド.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(customers[row])
        return customers[row] as? String
    }
    
    /*
     pickerが選択された際に呼ばれるデリゲートメソッド.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
/*        print("value: \(customers[row])")*/
    }
    @IBAction func handleAddMemoButton(_ sender: Any) {
        print(pvcname.selectedRow(inComponent: 0))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){

        if segue.identifier == "MemoViewController_Add" {
                var memoArray = try! Realm().objects(Memo.self).sorted(byKeyPath: "title", ascending: true)
                print("メモ数: \(memoArray.count)")
                print("ID: \(memo.id)")
                    try! realm.write {

                        if let title = tftitle.text {
                            self.memo.title = title
                        }
                        if let contents = tvmemo.text {
                            self.memo.contents = contents
                        }
                
                        let date = dpvdate.date
                        var counter = pvcname.selectedRow(inComponent: 0) - 1
                        self.memo.customer = customerArray[counter]
                        self.memo.date = date
                        realm.add(self.memo, update: .modified)
                    }
                print("メモを登録しました")
                let nextViewController:ViewController = segue.destination as! ViewController
        }
        if segue.identifier == "MemoViewController_Delete" {
            let query_category = "customer.name = '\(self.memo.customer.name)'"
            let targetMemo = realm.objects(Memo.self).filter(query_category)
            // ③ 該当メモを削除する
            do{
              try realm.write{
                realm.delete(targetMemo)
              }
            }catch {
              print("Error \(error)")
            }
            print("メモを削除しました")
        }
        if segue.identifier == "CustomerViewController" {
            let nextViewController:CustomerViewController = segue.destination as! CustomerViewController
            var customer = Customer()
            if pvcname.selectedRow(inComponent: 0) > 0 {
                customer = customerArray[pvcname.selectedRow(inComponent: 0) - 1]
            }
            
            let allCustomers = realm.objects(Customer.self)
            if pvcname.selectedRow(inComponent: 0) == 0 {
                print("新しい顧客です")
                customer = Customer()
                if allCustomers.count > 0 {
                    customer.id = allCustomers.max(ofProperty: "id")! + 1
                }
                nextViewController.customer = customer
            } else {
                nextViewController.customer = customer
            }
        }
    }
    
    @IBAction func handleRemoveMemoButton(_ sender: Any) {

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
