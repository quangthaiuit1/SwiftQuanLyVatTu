//
//  IndexViewController.swift
//  QuanLyVatTu
//
//  Created by Macintosh HD on 4/7/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController {

    @IBOutlet var viewSearchDate: UIView!
    @IBOutlet weak var textFieldTuNgay: UITextField!
    @IBOutlet weak var textFieldDenNgay: UITextField!
    
    @IBOutlet weak var btnPhieuNhap: UIButton!
    
    private var datePickerTuNgay: UIDatePicker?
    private var datePickerDenNgay: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ("Chương trình vật tư")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchDate))
        
        //init from date to date
        DispatchQueue.main.async {
            VariablesStatic.DEN_NGAY = self.getCurrentDate()
            VariablesStatic.TU_NGAY = self.getLast7Days()
        }
        
        //Chon ngay
        datePickerTuNgay = UIDatePicker()
        datePickerDenNgay = UIDatePicker()
        datePickerTuNgay?.datePickerMode = .date
        datePickerTuNgay?.addTarget(self, action: #selector(IndexViewController.dateChangedTuNgay(datePicker:)), for: .valueChanged)
        datePickerDenNgay?.datePickerMode = .date
        datePickerDenNgay?.addTarget(self, action: #selector(IndexViewController.dateChangedDenNgay(datePicker:)), for: .valueChanged)
        textFieldTuNgay.inputView = datePickerTuNgay
        textFieldDenNgay.inputView = datePickerDenNgay
        //Xử lý ẩn popup datePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    //Get current Date
    func getCurrentDate() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        //  dateFormatter.dateFormat = "dd-MM-YYYY HH:mm:ss"
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm:ss"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
//        let interval = date.timeIntervalSince1970
        return dateString
    }
    //Get last 7 days starting from today
    func getLast7Days() -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm:ss"
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = -200
        let last7DaysTemp = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        let last7Days = dateFormatter.string(from: last7DaysTemp!)
        return last7Days
    }
    
    //Chon ngay nhap
    @objc func dateChangedTuNgay(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        textFieldTuNgay.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    @objc func dateChangedDenNgay(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        textFieldDenNgay.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    //Bỏ popup chọn ngày
    @objc func viewTapped(gestureRecognizer: UIGestureRecognizer){
        view.endEditing(true)
    }
    //Xử lý tìm kiếm theo ngày
    @objc func handleSearchDate() {
        self.view.addSubview(viewSearchDate)
        viewSearchDate.center = self.view.center
    }
    @IBAction func chonPhieuNhapTam(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let phieuNhapTamScreen = sb.instantiateViewController(withIdentifier: "STPhieuNhapTam") as! PhieuNhapTamViewController
        self.navigationController?.pushViewController(phieuNhapTamScreen, animated: true)
    }
    @IBAction func chonPhieuXuatTam(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let phieuXuatTamScreen = sb.instantiateViewController(withIdentifier: "STPhieuXuatTam")
        self.navigationController?.pushViewController(phieuXuatTamScreen, animated: true)
    }
    
    @IBAction func buttonDongYTapped(_ sender: Any) {
        VariablesStatic.TU_NGAY = textFieldTuNgay.text!
        VariablesStatic.DEN_NGAY = textFieldDenNgay.text!
        viewSearchDate.removeFromSuperview()
    }
}
