import UIKit
import Alamofire

class DanhSachLoHangViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var chitietPhieunhaptams = [ChiTietPhieuNhapTam]()
    var index: Int?
    var phieuNhapTam: PhieuNhapTam?
//    var lohangs = [LoHang]()
    var lohangsReceivedFromThongTinPNT = [LoHang]()
    var idPhieuNhapTam: Int?
    var idChiTietPhieuNhap: Int?
    @IBOutlet weak var tableViewDanhSachLH: UITableView!
    @IBOutlet weak var imageClose: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageClose.image = UIImage.init(named: "close24")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chitietPhieunhaptams[index!].loHangs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellDanhSachLoHang") as? DanhSachLoHangTableViewCell else {
            return UITableViewCell()
        }
        cell.fillData(chitietPhieunhaptams[index!].loHangs[indexPath.row])
        cell.buttonDelete.addTarget(self, action: #selector(removeItem(_:)), for: .touchUpInside)
        cell.buttonDelete.tag = indexPath.row
        return cell
    }
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func removeItem (_ sender: UIButton) {
        let id = sender.tag
        for i in 0..<chitietPhieunhaptams[index!].loHangs.count {
            if chitietPhieunhaptams[index!].loHangs[id].id == chitietPhieunhaptams[index!].loHangs[i].id {
                chitietPhieunhaptams[index!].loHangs.remove(at: i)
                break
            }
        }
        tableViewDanhSachLH.reloadData()
    }
    
    @IBAction func buttonCapNhatTapped (_ sender: UIButton) {
        let chiTietPhieuNhapTamSend = ChiTietPhieuNhapTamSend(phieuNhapTam!.id,phieuNhapTam!.ngay,phieuNhapTam!.maphieu,phieuNhapTam!.loaiphieu,phieuNhapTam!.dataolohang ,phieuNhapTam!.kiemtra,phieuNhapTam!.nhacungcap, chitietPhieunhaptams)
                
                //Convert object to json
                let encodedData = try? JSONEncoder().encode(chiTietPhieuNhapTamSend)
                let json = String(data: encodedData!, encoding: String.Encoding.utf8)
                //Send params
                let headers: HTTPHeaders = [
                    "Content-Type": GenericsStatic.CONTENT_TYPE,
                    "database": GenericsStatic.CHI_NHANH,
                    "token": GenericsStatic.TOKEN
                ]
                
                let params:[String: Any] = [
                    "cm" : "luuphieunhaptam",
                    "dt" : json!
        ]
        //        print(json!)
        let url = GenericsStatic.URL +  "phieunhaptam"
        Alamofire.request(url,method: .post,parameters: params,headers: headers).responseJSON{(response) in
            switch response.result {
            case .success(let value):
                let valueDictionary = value as? NSDictionary
                let error = valueDictionary!["err"] as! Int
                if error == 0 {
                    //Tạo alert controller
                    let alert = UIAlertController(title: "Thông báo", message: "Lưu thành công!", preferredStyle: .alert)
                    //Tạo hành động
                    let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                        self.dismiss(animated: true)
                        print("Thành công!")
                    }
                    alert.addAction(okAction)
                    self.present(alert,animated: true,completion: nil)
                }
                else {
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
}
