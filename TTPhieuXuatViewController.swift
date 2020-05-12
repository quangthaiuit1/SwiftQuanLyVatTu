import UIKit
import Alamofire

class TTPhieuXuatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PassDataToVC{
    
//    var listPhieuXuatTamDetail = [ChiTietPhieuXuatTamAndLoHangXuat]()
    
    
    @IBOutlet weak var labelNoiNhan: UILabel!
    @IBOutlet weak var labelMaPhieu: UILabel!
    @IBOutlet weak var labelNgay: UILabel!
    @IBOutlet weak var labelKho: UILabel!
    @IBOutlet weak var tableViewChiTietPXT: UITableView!
    @IBOutlet weak var buttonDaXuat: UIButton!
    
    
    //Danh sách biến hứng giá trị
    var noinhan: String?
    var maphieu: String?
    var ngay: String?
    var kho: String?
    var idPhieuXuatTam: Int?
    var valueButtonDaXuat: Bool?
    
    var chiTietPhieuXuatTam = [ChiTietPXT]()
    
    var bienTest: Double?
    
    var delegate2: PassDataToVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông tin phiếu xuất tạm"
        //Điền thông tin phần mô tả
        fillTitleInfo()
        if valueButtonDaXuat! {
            self.buttonDaXuat.isSelected = true
        }
        sendPostRequest()
    }
       
    func passData(SoluongThucXuat soluong: Double, IndexPathCell indexPathThongTinPX: Int, Lohang lohang: [XuatLoHang]) {
        let indexPostion = IndexPath(row: indexPathThongTinPX, section: 0)
        chiTietPhieuXuatTam[indexPathThongTinPX].soluongThucXuat = soluong
        tableViewChiTietPXT.reloadRows(at: [indexPostion], with: .none)
        //Check lô hàng mới trùng lô hàng thì tăng số lượng lên.
        for i in lohang {
            //Check details cũ có lô hàng nào chưa
            if chiTietPhieuXuatTam[indexPathThongTinPX].loHangXuats.count > 0 {
                var exist = false
                for j in 0..<chiTietPhieuXuatTam[indexPathThongTinPX].loHangXuats.count {
                    if i.idlohang == chiTietPhieuXuatTam[indexPathThongTinPX].loHangXuats[j].idlohang {
                        self.chiTietPhieuXuatTam[indexPathThongTinPX].loHangXuats[j].sllohang = self.chiTietPhieuXuatTam[indexPathThongTinPX].loHangXuats[j].sllohang + i.sllohang
                        exist = true
                        break
                    }
                }
                if exist == false{
                    self.chiTietPhieuXuatTam[indexPathThongTinPX].loHangXuats.append(i)
                }
            }
            else {
                chiTietPhieuXuatTam[indexPathThongTinPX].loHangXuats.append(i)
            }
        }
    }
    
    func fillTitleInfo(){
        self.labelNoiNhan.text = noinhan
        self.labelNgay.text = ngay
        self.labelMaPhieu.text = maphieu
        self.labelKho.text = kho
    }
    
    func sendPostRequest(){
        let headers: HTTPHeaders = [
            "Content-Type": VariablesStatic.CONTENT_TYPE,
            "database": VariablesStatic.CHI_NHANH,
            "token": VariablesStatic.TOKEN
        ]
        
        let params:[String: Any] = [
            "cm" : "chitietphieuxuattam",
            "dt" : String(idPhieuXuatTam!)
        ]
        
        let url = URL.url + "phieuxuattam"
        Alamofire.request(url,method: .post,parameters: params,headers: headers).responseJSON{(response) in
            switch response.result {
            case .success(let value):
                // Handler Login Successecode(Customer.self, from: jsonData!)
                let dataNSDictionary = value as? NSDictionary
                let string = dataNSDictionary!["dt"]! as? String
                //                let data = string!.data(using: .utf8)!
                do {
                    if let json = string!.data(using: String.Encoding.utf8){
                        if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                            let jsonData1 =  jsonData["phieuXuatTamDetails"]!
                            for j in jsonData1  as! [AnyObject] {
                                //Chú ý phải unwrap hết trước khi cast sang string
                                let id = j["id"]!! as! Int
                                let maVatTu = j["mavt"] as! String
                                let tenVatTu = j["tenvt"] as! String
                                let soluongYeuCau = j["slyeucau"]!! as! Double
                                let soluongThucXuat = j["slthucxuat"]!! as! Double
                                var loHangXuats = [XuatLoHang]()
                                let lohangByIdDetailsDictionary = j["loHangXuats"] as? [[String: Any]]
                                for i in lohangByIdDetailsDictionary! {
                                    let idlohangByDetails = i["idlohang"] as! Int
                                    var ngaynhapByDetails = ""
                                    if i["ngaynhap"] != nil {
                                        ngaynhapByDetails = i["ngaynhap"] as! String
                                    }
                                    let malhByDetails = i["malh"] as! String
                                    let sllohangByDetails = i["sllohang"] as! Double
                                    var ngayhethanByDetails = ""
                                    if i["ngayhethan"] != nil {
                                        ngayhethanByDetails = i["ngayhethan"] as! String
                                    }
                                    let lohangxuatTemp = XuatLoHang(idlohangByDetails,malhByDetails,ngaynhapByDetails,ngayhethanByDetails,sllohangByDetails)
                                    loHangXuats.append(lohangxuatTemp)
                                }
                                
                                let  temp = ChiTietPXT(id,maVatTu,tenVatTu,soluongYeuCau,soluongThucXuat,loHangXuats)
                                self.chiTietPhieuXuatTam.append(temp)
                            }
                            DispatchQueue.main.async {
                                self.tableViewChiTietPXT.reloadData()
                            }
                        }
                    } else {
                        print("bad json")
                    }
                } catch let error as NSError {
                    print(error)
                }
            case .failure(let error):
                // Handler Login Failure
                debugPrint(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellThongTinPhieuXuatTam") as? TTPhieuXuatTamTableViewCell else {
            return UITableViewCell()
        }
        cell.fillData(chiTietPhieuXuatTam[indexPath.row])
        
        // Xử lý nút trong cell
        cell.buttonEye.tag = indexPath.row
        cell.buttonEye.addTarget(self, action: #selector(eyeTapped(_:)), for: .touchUpInside)
        cell.buttonPencil.tag = indexPath.row
        cell.buttonPencil.addTarget(self, action: #selector(pencilTapped(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chiTietPhieuXuatTam.count
    }
    @objc func pencilTapped(_ sender: UIButton){
        guard let xuatLoHangScreen = storyboard?.instantiateViewController(withIdentifier: "STXuatLoHang") as? XuatLoHangViewController else {
            return
        }
        //Tạo liên kết delegate để delegate khác nil
        xuatLoHangScreen.delegate = self
        
        xuatLoHangScreen.modalPresentationStyle = .overFullScreen
        xuatLoHangScreen.modalTransitionStyle = .crossDissolve
        //Chỗ này cùi chuối: không biết pass param
        xuatLoHangScreen.idPhieuXuatTam = self.idPhieuXuatTam
        xuatLoHangScreen.idChiTietPhieuXuat = chiTietPhieuXuatTam[sender.tag].id
        xuatLoHangScreen.ngay = self.labelNgay.text!
        xuatLoHangScreen.indexPathTableThongTinPX = sender.tag
        //Test kiểu dữ liệu.
        xuatLoHangScreen.idChiTietPhieuXuat = chiTietPhieuXuatTam[sender.tag].id
        xuatLoHangScreen.slYeuCau = chiTietPhieuXuatTam[sender.tag].soluongYeuCau
        xuatLoHangScreen.slThucXuat = chiTietPhieuXuatTam[sender.tag].soluongThucXuat
        present(xuatLoHangScreen, animated: true)
    }
    @objc func eyeTapped(_ sender: UIButton){
        guard let xuatLoHangScreen = storyboard?.instantiateViewController(withIdentifier: "STDanhSachLoHangXuat") as? DSLoHangXuatViewController else {
            return
        }
        xuatLoHangScreen.modalPresentationStyle = .overFullScreen
        xuatLoHangScreen.modalTransitionStyle = .crossDissolve
        xuatLoHangScreen.dsLoHangXuats = chiTietPhieuXuatTam[sender.tag].loHangXuats
        present(xuatLoHangScreen, animated: true)
    }
    
    @IBAction func daXuatTapped(_ sender: Any) {
        if self.self.buttonDaXuat.isSelected {
            self.buttonDaXuat.isSelected = false
        }else{
            self.buttonDaXuat.isSelected = true
        }
    }
    
    //Chưa xử lý xong
    @IBAction func luuPhieuTapped(_ sender: Any) {
        let chiTietPhieuXuatTamSend = ChiTietPhieuXuatTamSend(idPhieuXuatTam!,ngay!,maphieu!,kho!,valueButtonDaXuat!,noinhan!, chiTietPhieuXuatTam)
        //Convert object to json
        let encodedData = try? JSONEncoder().encode(chiTietPhieuXuatTamSend)
        let json = String(data: encodedData!, encoding: String.Encoding.utf8)
        let headers: HTTPHeaders = [
            "Content-Type": VariablesStatic.CONTENT_TYPE,
            "database": VariablesStatic.CHI_NHANH,
            "token": VariablesStatic.TOKEN
        ]
        let params:[String: Any] = [
            "cm" : "luuphieuxuattam",
            "dt" : json!
        ]
//        print(json!)
        let url = URL.url + "phieuxuattam"
        Alamofire.request(url,method: .post,parameters: params,headers: headers).responseJSON{(response) in
            switch response.result {
            case .success(let value):
                // Handler Login Successecode(Customer.self, from: jsonData!)
                let valueDictionary = value as? NSDictionary
                let error = valueDictionary!["err"] as! Int
                if error == 0 {
                    let alert = UIAlertController(title: "Thông báo", message: "Lưu thành công!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
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
}

