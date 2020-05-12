import UIKit
import Alamofire

class ThongTinPhieuNhapTamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, sendDSLoHangToThongTinPNT{
   
    var txtNhaCungCap: String?
    var txtMaPhieu: String?
    var txtNgayNhap: String?
    var txtLoaiPhieu: String?
    var tongSLThucTe: Double = 0.0
    //Danh sách lô hàng vừa được thêm bên view thêm lô hàng
    var lohangsSendDanhSachLoHang = [LoHang]()
    //Danh sách Phiếu nhập tạm details
    var listPhieuNhapTamDetail = [ChiTietPhieuNhapTamAndLoHang]()

    @IBOutlet private weak var labelNhaCungCap: UILabel!
    @IBOutlet private weak var labelMaPhieu: UILabel!
    @IBOutlet private weak var labelNgayNhap: UILabel!
    @IBOutlet private weak var labelLoaiPhieu: UILabel!

    var valueButtonDaTao: Bool?
    var valueButtonKiemTra: Bool?
    
    @IBOutlet weak var buttonDaTao: UIButton!
    @IBOutlet weak var tableViewThongTinPhieuNhapTam: UITableView!
    // Biến danh sách:
    
    var chitietPhieunhaptams = [ChiTietPhieuNhapTam]()
    var idPhieuNhapTam: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông tin phiếu nhập tạm"
        //Gán dữ liệu
        self.labelNhaCungCap.text = txtNhaCungCap
        self.labelMaPhieu.text = txtMaPhieu
        self.labelLoaiPhieu.text = txtLoaiPhieu
        self.labelNgayNhap.text = txtNgayNhap
        //Check đã tạo hay chưa
        if valueButtonDaTao! {
            self.buttonDaTao.isSelected = true
        }
        //Xử lý ẩn popup datePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        tableViewThongTinPhieuNhapTam.dataSource = self
        tableViewThongTinPhieuNhapTam.delegate = self
        sendPostMethod()
    }
    
    func sendData(DanhSachLohang lohangs: [LoHang], IndexPathClick index: Int, TongSoLuong tongSL: Double) {
        let indexPostion = IndexPath(row: index, section: 0)
        chitietPhieunhaptams[index].soluongThucte = chitietPhieunhaptams[index].soluongThucte + tongSL
        //Thêm lô hàng mới tạo vào lô hàng cũ
        for i in lohangs {
            chitietPhieunhaptams[index].loHangs.append(i)
        }
        tableViewThongTinPhieuNhapTam.reloadRows(at: [indexPostion], with: .none)
        lohangsSendDanhSachLoHang = lohangs
        
        let phieuNhapTamDetailsTemp = ChiTietPhieuNhapTamAndLoHang(chitietPhieunhaptams[index].id, chitietPhieunhaptams[index].maVatTu,chitietPhieunhaptams[index].tenVatTu,chitietPhieunhaptams[index].soluongChungtu,chitietPhieunhaptams[index].soluongThucte,chitietPhieunhaptams[index].loHangs)
        listPhieuNhapTamDetail.append(phieuNhapTamDetailsTemp)
    }
    
    func sendPostMethod(){
        let headers: HTTPHeaders = [
            "Content-Type": VariablesStatic.CONTENT_TYPE,
            "database": VariablesStatic.CHI_NHANH,
            "token": VariablesStatic.TOKEN
        ]
        
        let params:[String: Any] = [
            "cm" : "chitietphieunhaptam",
            "dt" : String(describing: idPhieuNhapTam!)
        ]
        
        let url = URL.url +  "phieunhaptam"
        Alamofire.request(url,method: .post,parameters: params,headers: headers).responseJSON{(response) in
            switch response.result {
            case .success(let value):
                // Handler Login Successecode(Customer.self, from: jsonData!)
                let dataNSDictionary = value as? NSDictionary
                if dataNSDictionary!["dt"] != nil {
                    let string = dataNSDictionary!["dt"]! as? String
                    do {
                        if let json = string!.data(using: String.Encoding.utf8){
                            if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                let jsonData1 =  jsonData["phieuNhapTamDetails"]!
                                for j in jsonData1  as! [AnyObject] {
                                    let id = j["id"]! as! Int
                                    let maVatTu = j["mavt"] as! String
                                    let tenVatTu = j["tenvt"] as! String
                                    let soluongChungtu = j["slchungtu"]!! as! Double
                                    let soluongThucte =  j["slthucte"]!! as! Double
                                    var loHangs = [LoHang]()
                                    let loHangDictionary = j["loHangs"] as? [[String: Any]]
                                    for i in loHangDictionary! {
                                        let idLoHang = i["id"] as! Int
                                        let maLoHang = i["malh"] as! String
                                        let ngaynhapLoHang = i["ngaynhap"] as! String
                                        let ngayhethanLoHang = i["ngayhethan"] as! String
                                        let lhdatLoHang = i["lhdat"] as! Bool
                                        let slLoHang = i["sllohang"] as! Double
                                        let lohangTemp = LoHang(idLoHang,maLoHang,ngaynhapLoHang,ngayhethanLoHang,lhdatLoHang,slLoHang)
                                        loHangs.append(lohangTemp)
                                    }
                                    
                                    let  temp = ChiTietPhieuNhapTam(id,maVatTu,tenVatTu,soluongChungtu,soluongThucte,loHangs)
                                    self.chitietPhieunhaptams.append(temp)
                                }
                                DispatchQueue.main.async {
                                    self.tableViewThongTinPhieuNhapTam.reloadData()
                                }
                                
                            }
                        } else {
                            print("bad json")
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            case .failure(let error):
                // Handler Login Failure
                debugPrint(error)
            }
        }
    }
  
    //Bỏ popup chọn ngày
    @objc func viewTapped(gestureRecognizer: UIGestureRecognizer){
        view.endEditing(true)
    }
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellThongTinPhieuNhap") as! ThongTinPhieuNhapTableViewCell
        cell.fillData(chitietPhieunhaptams[indexPath.row])
        // Xử lý nút trong cell
        cell.buttonView.tag = indexPath.row
        cell.buttonView.addTarget(self, action: #selector(viewTapped(_:)), for: .touchUpInside)
        
        cell.buttonAdd.tag = indexPath.row
        cell.buttonAdd.addTarget(self, action: #selector(tapThemLoHang(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chitietPhieunhaptams.count
    }
    
    @IBAction func daTaoButtonTapped(_ sender: Any) {
        if self.buttonDaTao.isSelected {
            self.buttonDaTao.isSelected = false
        }else {
            self.buttonDaTao.isSelected = true
        }
    }
    
    @objc func tapThemLoHang(_ sender: UIButton) {
        guard let themLoHangScreen = storyboard?.instantiateViewController(withIdentifier: "STThemLoHang") as? ThemLoHangViewController else {
            return
        }
        themLoHangScreen.modalPresentationStyle = .overFullScreen
        themLoHangScreen.modalTransitionStyle = .crossDissolve
        themLoHangScreen.index = sender.tag
        themLoHangScreen.receiveData = self
        
        present(themLoHangScreen, animated: true)
    }
    
    
    @IBAction func viewTapped(_ sender: UIButton) {
        guard let danhSachLoHangScreen = storyboard?.instantiateViewController(withIdentifier: "STXemDanhSachLoHang") as? DanhSachLoHangViewController else {
            return
        }
        danhSachLoHangScreen.modalPresentationStyle = .overFullScreen
        danhSachLoHangScreen.modalTransitionStyle = .crossDissolve
        danhSachLoHangScreen.idPhieuNhapTam = self.idPhieuNhapTam
        danhSachLoHangScreen.idChiTietPhieuNhap = self.chitietPhieunhaptams[sender.tag].id
        danhSachLoHangScreen.lohangsReceivedFromThongTinPNT = self.lohangsSendDanhSachLoHang
        danhSachLoHangScreen.lohangs = self.chitietPhieunhaptams[sender.tag].loHangs
        present(danhSachLoHangScreen, animated: true)
    }
    @IBAction func buttonLuuPhieuTapped(_ sender: Any) {
        let id = idPhieuNhapTam!
        let ngay = txtNgayNhap!
        let maphieu = txtMaPhieu!
        let loaiphieu = txtLoaiPhieu!
        let dataolohang = valueButtonDaTao!
        let nhacungcap = txtNhaCungCap!
        let kiemtra = valueButtonKiemTra!
        
        let chiTietPhieuNhapTamSend = ChiTietPhieuNhapTamSend(id,ngay,maphieu,loaiphieu,dataolohang,kiemtra,nhacungcap, listPhieuNhapTamDetail)
        
        //Convert object to json
        let encodedData = try? JSONEncoder().encode(chiTietPhieuNhapTamSend)
        let json = String(data: encodedData!, encoding: String.Encoding.utf8)
        //Send params
        let headers: HTTPHeaders = [
            "Content-Type": VariablesStatic.CONTENT_TYPE,
            "database": VariablesStatic.CHI_NHANH,
            "token": VariablesStatic.TOKEN
        ]
        
        let params:[String: Any] = [
            "cm" : "luuphieunhaptam",
            "dt" : json!
        ]
        print(json!)
        let url = URL.url +  "phieunhaptam"
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
