//
//  InputViewController.swift
//  memoapp
//
//  Created by 内藤有紀 on 2022/06/03.
//

import UIKit

class InputViewController: UIViewController {
    @IBOutlet weak var ltitle: UILabel!
    @IBOutlet weak var lcname: UILabel!
    @IBOutlet weak var ldate: UILabel!
    @IBOutlet weak var lmemo: UILabel!
    @IBOutlet weak var pvcname: UIPickerView!
    @IBOutlet weak var dpvdate: UIDatePicker!
    @IBOutlet weak var tvmemo: UITextView!
    @IBOutlet weak var addCustomer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleCreateCustomerButton(_ sender: Any) {

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
