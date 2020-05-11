import UIKit
import Alamofire

class DSLoHangXuatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dsLoHangXuats = [XuatLoHang]()
    @IBOutlet weak var tableViewDSLoHangXuat: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        cell.fillData(dsLoHangXuats[indexPath.row])
        cell.buttonXoa.tag = indexPath.row
        cell.buttonXoa.addTarget(self, action: #selector(buttonXoaTapped), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dsLoHangXuats.count
    }
    
    @objc func buttonXoaTapped(_ sender: UIButton) {
        let id = sender.tag
        print("id \(id)")
        print(dsLoHangXuats[id].idlohang)
        //continued
        
    }
    
    @IBAction func closeTapped(_ sender: Any) {
         dismiss(animated: true)
    }
}
