import UIKit
import Alamofire

class PhieuNhapTamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableViewPhieuNhapTam: UITableView!
    
    var phieuNhapTams = [PhieuNhapTam]()
    var listIdPhieuNhapTamString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Phiếu nhập tạm"
        tableViewPhieuNhapTam.dataSource = self
        tableViewPhieuNhapTam.delegate = self
        phieuNhapTams.removeAll()
        sendPostRequest()
    }
    
    
    
    private func sendPostRequest(){
        let headers: HTTPHeaders = [
            "Content-Type": VariablesStatic.CONTENT_TYPE,
            "database": VariablesStatic.CHI_NHANH,
            "token": VariablesStatic.TOKEN
        ]
       let dt = "\(VariablesStatic.TU_NGAY),\(VariablesStatic.DEN_NGAY)"
        let params: [String: Any] = [
            "cm": "dsphieunhaptam",
            "dt": dt
        ]
        let url = VariablesStatic.URL + "phieunhaptam"
        let startTime = CFAbsoluteTimeGetCurrent()
        Alamofire.request(url,method: .post,parameters: params,headers: headers).responseJSON{(response) in
            switch response.result {
            case .success(let value):
                // Handler Login Successecode(Customer.self, from: jsonData!)
                let rs = value as? NSDictionary
                let error = rs!["err"]! as! Int
                if error == 0 {
                    let string = rs!["dt"]! as? String
                    let data = string!.data(using: .utf8)!
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                        {
                            for i in jsonArray {
                                
                                let id = i["id"]! as! Int
                                let ngay = i["ngay"] as! String
                                let maphieu = i["maphieu"] as! String
                                let loaiphieu = i["loaiphieu"] as! String
                                let dataolohang = i["dataolohang"] as! Bool
                                let kiemtra = i["kiemtra"] as! Bool
                                let nhacungcap = i["nhacungcap"] as! String
                                let  temp = PhieuNhapTam(id,ngay,maphieu,loaiphieu,dataolohang,kiemtra,nhacungcap)
                                self.phieuNhapTams.append(temp)
                            }
                            DispatchQueue.main.async {
                                self.tableViewPhieuNhapTam.reloadData()
                                let endTime = CFAbsoluteTimeGetCurrent() - startTime
                                print("Thời gian request phiếu nhập tạm: \(endTime)")
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
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phieuNhapTams.count
//        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellPhieuNhapTam",for: indexPath) as? PhieuNhapTamTableViewCell else {
            return UITableViewCell()
        }
        cell.fillData(phieuNhapTams[indexPath.row])
        cell.buttonChuyenPhieu.tag = indexPath.row
        cell.buttonChuyenPhieu.addTarget(self, action: #selector(chuyenPhieuTapped(_:)), for: .touchUpInside)
//        Test dữ liệu tạm
//        let phieuNhapTamTest = PhieuNhapTam("145609","20/02/1995","AB156/CD","BB",true ,false ,"Công ty cổ phần bột giặt LIX")
//        cell.fillData(phieuNhapTamTest)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Tao storyboard
        let st = UIStoryboard.init(name: "Main", bundle: nil)
        //Tao man hinh
        let thongTinPhieuNhapScreen = (st.instantiateViewController(withIdentifier: "STThongTinPhieuNhapTam") as? ThongTinPhieuNhapTamViewController)!
        //Du lieu chinh
        thongTinPhieuNhapScreen.txtNhaCungCap = phieuNhapTams[indexPath.row].nhacungcap
        thongTinPhieuNhapScreen.txtNgayNhap = phieuNhapTams[indexPath.row].ngay
        thongTinPhieuNhapScreen.txtMaPhieu = phieuNhapTams[indexPath.row].maphieu
        thongTinPhieuNhapScreen.txtLoaiPhieu = phieuNhapTams[indexPath.row].loaiphieu
        thongTinPhieuNhapScreen.idPhieuNhapTam = phieuNhapTams[indexPath.row].id
        thongTinPhieuNhapScreen.valueButtonDaTao = phieuNhapTams[indexPath.row].dataolohang
        thongTinPhieuNhapScreen.valueButtonKiemTra = phieuNhapTams[indexPath.row].kiemtra
        
        //Pust man hinh len
        self.navigationController?.pushViewController(thongTinPhieuNhapScreen, animated: true)
    }
    
    @objc func chuyenPhieuTapped(_ sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
    }
    
    //**** Chú ý có cell không lấy được data*****
    
    @IBAction func chuyenPhieuEndTapped(_ sender: UIButton) {
        var row  = 0
        var listIdPhieuNhapTam = [Int]()
        while row < phieuNhapTams.count { //iterate through the tableview's cells
            
            let indexPath : NSIndexPath = NSIndexPath(row: row, section: 0) //Create the indexpath to get the cell
            let cell = self.tableViewPhieuNhapTam.cellForRow(at:indexPath as IndexPath) as? PhieuNhapTamTableViewCell
            if cell?.buttonChuyenPhieu.isSelected == true {
                //Tạo 1 list id được chọn để gửi.
                listIdPhieuNhapTam.append(Int(cell!.labelId.text!)!)
            }
            row += 1
        }
        //Chuyển từ array Int to string
        for j in listIdPhieuNhapTam {
            if listIdPhieuNhapTamString.isEmpty {
                listIdPhieuNhapTamString = listIdPhieuNhapTamString + "\(j)"
            }else {
                listIdPhieuNhapTamString = listIdPhieuNhapTamString + "," + "\(j)"
            }
        }
        chuyenPhieu()
        self.listIdPhieuNhapTamString = ""
    }
    func chuyenPhieu(){
        let headers: HTTPHeaders = [
            "Content-Type": VariablesStatic.CONTENT_TYPE,
            "database": VariablesStatic.CHI_NHANH,
            "token": VariablesStatic.TOKEN
        ]
        let params: [String: Any] = [
            "cm": "chuyenphieunhaptam",
            "dt": listIdPhieuNhapTamString
        ]
        let url = VariablesStatic.URL + "phieunhaptam"
        Alamofire.request(url,method: .post,parameters: params,headers: headers).responseJSON{(response) in
            switch response.result {
            case .success(let value):
                // Handler Login Successecode(Customer.self, from: jsonData!)
                let rs = value as? NSDictionary
                let error = rs!["err"]! as? Int
                if error == 0 {
                    let alert = UIAlertController(title: "Thông báo", message: "Thành công!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                        self.tableViewPhieuNhapTam.reloadData()
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Thông báo", message: "Thất bại!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                        self.tableViewPhieuNhapTam.reloadData()
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                // Handler Login Failure
                debugPrint(error)
            }
        }
    }

    
}
