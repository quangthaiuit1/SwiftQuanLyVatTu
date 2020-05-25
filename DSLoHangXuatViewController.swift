import UIKit
import Alamofire

class DSLoHangXuatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var chiTietPhieuXuatTam = [ChiTietPXT]()
    var phieuXuatTam : PhieuXuatTam?
    var index: Int?
    @IBOutlet weak var tableViewDSLoHangXuat: UITableView!
    @IBOutlet weak var imageClose: UIImageView!
    var xuatLoHangDelegate: DanhSachLoHangVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageClose.image = UIImage.init(named: "close24")
    }
//    func sendPostMethod(){
//        let headers: HTTPHeaders = [
//            "Content-Type": "application/x-www-form-urlencoded",
//            "database": "HCM",
//            "token": "123"
//        ]
//
//        let params:[String: Any] = [
//            "cm" : "chitietphieuxuattam",
//            "dt" : String(idPhieuXuatTam!)
//        ]
//
//        let url = URL.url + "phieuxuattam"
//        Alamofire.request(url,method: .post,parameters: params,headers: headers).responseJSON{(response) in
//            switch response.result {
//            case .success(let value):
//                // Handler Login Successecode(Customer.self, from: jsonData!)
//                let dataNSDictionary = value as? NSDictionary
//                let string = dataNSDictionary!["dt"]! as? String
//                //                let data = string!.data(using: .utf8)!
//                do {
//                    if let json = string!.data(using: String.Encoding.utf8){
//                        if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
//                            // Xử lý list lồng list
//                            let phieuXuatTamDetails = jsonData["phieuXuatTamDetails"] as? [[String: Any]]
//                            for i in phieuXuatTamDetails! {
//                                //Kiểm tra có đúng chi tiết của phiếu đó không
//                                if self.idChiTietPhieuXuat! == i["id"]! as! Int {
//                                    let loHangXuat = i["loHangXuats"] as? [[String: Any]]
//                                    for j in loHangXuat! {
//                                        let id = j["idlohang"]! as! Int
//                                        let maLoHang = j["malh"] as! String
//                                        let ngaynhap = j["ngaynhap"] as! String
//                                        var ngayhethan = ""
//                                        if j["ngayhethan"] != nil {
//                                            ngayhethan = j["ngayhethan"] as! String
//                                        }
//                                        let soluongLoHang =  j["sllohang"]! as! Double
//                                        let  temp = XuatLoHang(id,maLoHang,ngaynhap,ngayhethan,soluongLoHang)
//                                        self.dsLoHangXuats.append(temp)
//                                        print(self.dsLoHangXuats.count)
//                                    }
//                                }
//                            }
//                            DispatchQueue.main.async {
//                                self.tableViewDSLoHangXuat.reloadData()
//                            }
//                        }
//                    } else {
//                        print("bad json")
//                    }
//                } catch let error as NSError {
//                    print(error)
//                }
//            case .failure(let error):
//                // Handler Login Failure
//                debugPrint(error)
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellDanhSachLoHangXuat") as? DSLoHangXuatTableViewCell else {
            return UITableViewCell()
        }
        cell.fillData(chiTietPhieuXuatTam[index!].loHangXuats[indexPath.row])
        cell.buttonXoa.tag = indexPath.row
        cell.buttonXoa.addTarget(self, action: #selector(buttonXoaTapped), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chiTietPhieuXuatTam[index!].loHangXuats.count
    }
    
    @objc func buttonXoaTapped(_ sender: UIButton) {
        let id = sender.tag
        for i in 0..<chiTietPhieuXuatTam[index!].loHangXuats.count {
            if chiTietPhieuXuatTam[index!].loHangXuats[id].idlohang == chiTietPhieuXuatTam[index!].loHangXuats[i].idlohang {
                chiTietPhieuXuatTam[index!].loHangXuats.remove(at: i)
                break
            }
        }
        tableViewDSLoHangXuat.reloadData()
    }
    
    @IBAction func capNhatTapped(_ sender: UIButton){
        let chiTietPhieuXuatTamSend = ChiTietPhieuXuatTamSend(phieuXuatTam!.id, phieuXuatTam!.ngay, phieuXuatTam!.maphieu, phieuXuatTam!.kho, phieuXuatTam!.daxuat, phieuXuatTam!.noinhan, chiTietPhieuXuatTam)
        //Convert object to json
        let encodedData = try? JSONEncoder().encode(chiTietPhieuXuatTamSend)
        let json = String(data: encodedData!, encoding: String.Encoding.utf8)
        let headers: HTTPHeaders = [
            "Content-Type": GenericsStatic.CONTENT_TYPE,
            "database": GenericsStatic.CHI_NHANH,
            "token": GenericsStatic.TOKEN
        ]
        let params:[String: Any] = [
            "cm" : "luuphieuxuattam",
            "dt" : json!
        ]
        //        print(json!)
        let url = GenericsStatic.URL + "phieuxuattam"
        Alamofire.request(url,method: .post,parameters: params,headers: headers).responseJSON{(response) in
            switch response.result {
            case .success(let value):
                // Handler Login Successecode(Customer.self, from: jsonData!)
                let valueDictionary = value as? NSDictionary
                let error = valueDictionary!["err"] as! Int
                if error == 0 {
                    let alert = UIAlertController(title: "Thông báo", message: "thành công!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                        // handle so luong thuc xuat
                        var soluongThucXuat = 0.0
                        for i in self.chiTietPhieuXuatTam[self.index!].loHangXuats{
                            soluongThucXuat = soluongThucXuat + i.sllohang
                        }
                        if self.xuatLoHangDelegate != nil {
                            self.xuatLoHangDelegate?.passSoLuongThucXuat(soluongThucXuat, self.index!)
                        }
                        self.dismiss(animated: true)
                        print("Thành công!")
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }else {
                    //Tạo alert controller
                    let alert = UIAlertController(title: "Thông báo", message: "Thất bại!", preferredStyle: .alert)
                    //Tạo hành động
                    let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                        print("Thất bại!")
                    }
                    alert.addAction(okAction)
                    self.present(alert,animated: true,completion: nil)
                }
            case .failure(let error):
                // Handler Login Failure
                debugPrint(error)
            }
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
         dismiss(animated: true)
    }
}

protocol DanhSachLoHangVCDelegate {
    //pass so luong thuc xuat ve view chi tiet xuat
    func passSoLuongThucXuat (_ soluongThucXuat: Double, _ index: Int)
}
