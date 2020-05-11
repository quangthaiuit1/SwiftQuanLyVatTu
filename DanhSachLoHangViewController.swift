//
//  DanhSachLoHangViewController.swift
//  QuanLyVatTu
//
//  Created by Macintosh HD on 4/22/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit
import Alamofire

class DanhSachLoHangViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var lohangs = [LoHang]()
    var lohangsReceivedFromThongTinPNT = [LoHang]()
    var idPhieuNhapTam: Int?
    var idChiTietPhieuNhap: Int?
    @IBOutlet weak var tableViewDanhSachLH: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lohangs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellDanhSachLoHang") as? DanhSachLoHangTableViewCell else {
            return UITableViewCell()
        }
        cell.fillData(lohangs[indexPath.row])
        return cell
    }
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
