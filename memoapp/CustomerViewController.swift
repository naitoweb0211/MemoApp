//
//  CustomerViewController.swift
//  memoapp
//
//  Created by 内藤有紀 on 2022/06/03.
//

import UIKit
import RealmSwift

class CustomerViewController: UIViewController {
    @IBOutlet weak var lcustomer: UILabel!
    @IBOutlet weak var cname: UITextField!
    @IBOutlet weak var addCustomer: UIButton!
    @IBOutlet weak var removeCustomer: UIButton!
    var customer: Customer = Customer()
    let realm = try! Realm()  // ←追加
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomer.backgroundColor = UIColor.orange
        removeCustomer.backgroundColor = UIColor.orange
        self.cname.text = customer.name
        
        print("顧客画面に来ました")
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){

        try! realm.write {
            var name = ""
            if let cname = self.cname.text {
                name = cname
            }
            var customerArray = try! Realm().objects(Customer.self).sorted(byKeyPath: "name", ascending: true)
            self.customer.name = name
            realm.add(self.customer, update: .modified)
        }

            print("顧客を登録しました")



        if segue.identifier == "CustomerViewController_Add" {

            let nextViewController:MemoViewController = segue.destination as! MemoViewController
        }
        if segue.identifier == "CustomerViewController_Delete" {
            let nextViewController:ViewController = segue.destination as! ViewController
            var query_category = "customer.name = '\(customer.name)'"
            let targetMemo = realm.objects(Memo.self).filter(query_category)
            // ③ 該当メモを削除する
            do{
              try realm.write{
                realm.delete(targetMemo)
              }
            }catch {
              print("Error \(error)")
            }
            query_category = "name = '\(customer.name)'"
            let targetCustomer = realm.objects(Customer.self).filter(query_category)
            // ③ 該当顧客を削除する
            do{
              try realm.write{
                realm.delete(targetCustomer)
              }
            }catch {
              print("Error \(error)")
            }
            print("顧客を削除しました")
        }
    }
    
    
    @IBAction func handleRemoveCustomerButton(_ sender: Any) {
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
