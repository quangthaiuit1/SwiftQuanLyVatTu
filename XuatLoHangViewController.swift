import UIKit
import Alamofire

protocol PassDataToVC {
    func passData(SoluongThucXuat soluong: Double, IndexPathCell indexPathThongTinPX: Int, Lohang lohang: [XuatLoHang])
}

class XuatLoHangViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    //Khai báo 1 biến thuộc protocol
    var delegate: PassDataToVC?
    
    var sendSoLuongThucXuat: ((String) -> Double)?
    var slYeuCau: Double?
    var slThucXuat: Double?
    var tongSoLuongThucXuat: Double? = 0.0
    var indexPathTableThongTinPX: Int?
    @IBOutlet weak var labelSoLuongYeuCau: UILabel!
    @IBOutlet weak var labelSoLuongThucXuat: UILabel!
    @IBOutlet weak var tableViewXuatLoHang: UITableView!
    @IBOutlet weak var imageClose: UIImageView!
    var idPhieuXuatTam: Int?
    var idChiTietPhieuXuat: Int?
    var ngay: String?
    var xuatLoHangs = [XuatLoHang]()
    var xuatLoHangsSend = [XuatLoHang]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelSoLuongYeuCau.text = String(slYeuCau!)
        self.labelSoLuongThucXuat.text = String(slThucXuat! + tongSoLuongThucXuat!)
        self.imageClose.image = UIImage.init(named: "close24")
        self.tongSoLuongThucXuat = self.tongSoLuongThucXuat! + slThucXuat!
        sendPostMethod()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    //Hidden keyboard
    @objc func viewTapped(gestureRecognizer: UIGestureRecognizer){
        view.endEditing(true)
    }
    
    func sendPostMethod(){
        let headers: HTTPHeaders = [
            "Content-Type": GenericsStatic.CONTENT_TYPE,
            "database": GenericsStatic.CHI_NHANH,
            "token": GenericsStatic.TOKEN
        ]
        
        let dt = String(idChiTietPhieuXuat!) + "," + ngay!
        let params:[String: Any] = [
            "cm" : "danhsachlohang",
            "dt" : dt
        ]
        
        let url = GenericsStatic.URL + "phieuxuattam"
        Alamofire.request(url,method: .post,parameters: params,headers: headers).responseJSON{(response) in
            switch response.result {
            case .success(let value):
                // Handler Login Successecode(Customer.self, from: jsonData!)
                let dataNSDictionary = value as? NSDictionary
                //Check có dữ liệu hay không
                let error = dataNSDictionary!["err"] as? Int
                if error! != 1 {
                    let string = dataNSDictionary!["dt"]! as? String
                    let data = string!.data(using: .utf8)!
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                        {
                            for i in jsonArray {
                                
                                let id = i["id"] as! Int
                                let malh = i["malh"] as! String
                                var ngaynhap = ""
                                if i["ngaynhap"] != nil {
                                    ngaynhap = i["ngaynhap"] as! String
                                }
                                var ngayhethan = ""
                                if i["ngayhethan"] != nil {
                                    ngayhethan = i["ngayhethan"] as! String
                                }
                                let sllohang = i["sllohang"]! as! Double
                                let  temp = XuatLoHang(id,malh,ngaynhap,ngayhethan,sllohang)
                                self.xuatLoHangs.append(temp)
                            }
                            DispatchQueue.main.async {
                                self.tableViewXuatLoHang.reloadData()
                            }
                        }else {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellXuatLoHang") as? XuatLoHangTableViewCell else {
            return UITableViewCell()
        }
        cell.fillData(xuatLoHangs[indexPath.row])
        cell.buttonOkXuat.tag = indexPath.row
        cell.buttonOkXuat.setImage(UIImage(named: "UnCheckbox"), for: .normal)
        cell.buttonOkXuat.setImage(UIImage(named: "Checkbox"), for: .selected)
        cell.buttonOkXuat.addTarget(self, action: #selector(okXuatLoHangTapped(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xuatLoHangs.count
    }
    
    //Xử lý chọn xuất
    @objc func okXuatLoHangTapped(_ sender: UIButton) {
        
        if self.slYeuCau! == self.slThucXuat! ||  self.slYeuCau! < self.slThucXuat!{
            let alert = UIAlertController(title: "Thông báo", message: "Đã đủ số lượng.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                case _ :
                    print("Thái")
                }}))
            self.present(alert, animated: true)
        }
            
        else{
            if sender.isSelected == false {
                sender.isSelected = true
            }else {
                sender.isSelected = false
            }
        }
    }
    
    //Xử lý nhấn lưu xuất
    @IBAction func luuXuatTapped(_ sender: Any) {
        
        //Check Tổng số lượng thực xuất với sl yêu cầu
        var row  = 0
        //Lặp để kiểm tra row nào có nút OK được nhấn
        while row < xuatLoHangs.count { //iterate through the tableview's cells
            
            let indexPath : NSIndexPath = NSIndexPath(row: row, section: 0) //Create the indexpath to get the cell
            let cell = self.tableViewXuatLoHang.cellForRow(at:indexPath as IndexPath) as? XuatLoHangTableViewCell
            if cell?.buttonOkXuat.isSelected == true {
                if cell!.textFieldSoLuong.text!.isEmpty{
                    print("TextField is Cell \(row) is Empty")
                }
                else{
                    let soluong = Double(cell!.textFieldSoLuong.text!)
                    self.tongSoLuongThucXuat = self.tongSoLuongThucXuat! + soluong!
                    //Kiểm tra lô hàng quá số lượng
                    if tongSoLuongThucXuat! > slYeuCau!{
                        self.tongSoLuongThucXuat = self.tongSoLuongThucXuat! - soluong!
                        let thatBai = UIAlertController(title: "Thông báo", message: "Vượt quá số lượng", preferredStyle: .alert)
                        let okTapped = UIAlertAction(title: "OK", style: .default, handler: nil)
                        thatBai.addAction(okTapped)
                        self.present(thatBai, animated: true, completion: nil)
                    }
                    else {
                        let id = Int(cell!.labelId.text!)
                        let malh = cell!.labelMaLH.text!
                        let ngaynhap = cell!.labelNgayNhap.text!
                        let ngayhethan = cell!.labelNgayHetHan.text!
                        
                        let xuatLoHangTemp = XuatLoHang(id!,malh,ngaynhap,ngayhethan,soluong!)
                        self.xuatLoHangsSend.append(xuatLoHangTemp)
                    }
                }
            }
            row += 1
        }
        if self.tongSoLuongThucXuat! > self.slYeuCau! {
            let alert = UIAlertController(title: "Thông báo", message: "Số lượng thực xuất vượt quá số lượng yêu cầu", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                print("Thất bại")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if self.tongSoLuongThucXuat != 0 && self.tongSoLuongThucXuat! <= self.slYeuCau!{
                if delegate != nil {
                    delegate?.passData(SoluongThucXuat: self.tongSoLuongThucXuat!, IndexPathCell: self.indexPathTableThongTinPX!, Lohang: self.xuatLoHangsSend)
                }
                dismiss(animated: true)
            }
        }
    }
    //Xử lý đóng popup
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
}
