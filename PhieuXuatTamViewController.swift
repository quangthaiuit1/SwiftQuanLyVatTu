import UIKit
import Alamofire

class PhieuXuatTamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewPhieuXuatTam: UITableView!
    var phieuXuatTams = [PhieuXuatTam]()
    var listIdPhieuXuatTamString = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Phiếu xuất tạm"
        phieuXuatTams.removeAll()
        sendPostRequest()
    }
    
    func sendPostRequest () {
        let headers: HTTPHeaders = [
            "Content-Type": GenericsStatic.CONTENT_TYPE,
            "database": GenericsStatic.CHI_NHANH,
            "token": GenericsStatic.TOKEN
        ]
        let dt = "\(GenericsStatic.TU_NGAY),\(GenericsStatic.DEN_NGAY)"
        let params: [String: Any] = [
            "cm": "dsphieuxuattam",
            "dt": dt
        ]
        let url = GenericsStatic.URL + "phieuxuattam"
        
        //Test time
        let startTime = CFAbsoluteTimeGetCurrent()
        
        Alamofire.request(url,method: .post,parameters: params,headers: headers).responseJSON{(response) in
            switch response.result {
            case .success(let value):
                // Handler Login Successecode(Customer.self, from: jsonData!)
                let rs = value as? NSDictionary
                if rs!["dt"] != nil {
                    let string = rs!["dt"]! as? String
                    let data = string!.data(using: .utf8)!
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                        {
                            for i in jsonArray {
                                
                                let id = i["id"]! as! Int
                                let ngay = i["ngay"] as! String
                                let maphieu = i["maphieu"] as! String
                                var kho = ""
                                if i["kho"] != nil {
                                    kho = i["kho"] as! String
                                }
                                let daxuat = i["daxuat"] as! Bool
                                let noinhan = i["noinhan"] as! String
                                let  temp = PhieuXuatTam(id,ngay,maphieu,kho,daxuat,noinhan)
                                self.phieuXuatTams.append(temp)
                            }
                            DispatchQueue.main.async {
                                self.tableViewPhieuXuatTam.reloadData()
                                let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                                print("Thời gian request phiếu xuất tạm: \(timeElapsed) s.")
                            }
                        } else {
                            print("bad json")
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
                else {
                    self.tableViewPhieuXuatTam.reloadData()
                }
            case .failure(let error):
                // Handler Login Failure
                debugPrint(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CellPhieuXuatTam",for: indexPath) as! PhieuXuatTamTableViewCell 
        cell.fillData(phieuXuatTams[indexPath.row])
        cell.buttonChuyenPhieu.tag = indexPath.row
        cell.buttonChuyenPhieu.addTarget(self, action: #selector(chuyenPhieuTapped), for: .touchUpInside)
        cell.layoutIfNeeded()
        return cell
    }
    
    @objc func chuyenPhieuTapped (_ sender: UIButton){
        if sender.isSelected == true {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phieuXuatTams.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Tao storyboard
        let st = UIStoryboard.init(name: "Main", bundle: nil)
        //Tao man hinh
        let thongTinPhieuXuatTamScreen = st.instantiateViewController(withIdentifier: "STThongTinPhieuXuatTam") as? TTPhieuXuatViewController
        //Gán gía trị cho title info chi tiết phiếu xuất
        thongTinPhieuXuatTamScreen?.noinhan = phieuXuatTams[indexPath.row].noinhan
        thongTinPhieuXuatTamScreen?.maphieu = phieuXuatTams[indexPath.row].maphieu
        thongTinPhieuXuatTamScreen?.ngay = phieuXuatTams[indexPath.row].ngay
        thongTinPhieuXuatTamScreen?.kho = phieuXuatTams[indexPath.row].kho
        thongTinPhieuXuatTamScreen?.idPhieuXuatTam = phieuXuatTams[indexPath.row].id
        thongTinPhieuXuatTamScreen?.valueButtonDaXuat = phieuXuatTams[indexPath.row].daxuat
        
        self.navigationController?.pushViewController(thongTinPhieuXuatTamScreen!, animated: true)
    }
    
    //**** Chú ý có cell không lấy được data*****
    @IBAction func chuyenPhieuEndTapped(_ sender: UIButton) {
        var row  = 0
        var listIdPhieuXuatTam = [Int]()
        while row < phieuXuatTams.count { //iterate through the tableview's cells
            
            let indexPath : NSIndexPath = NSIndexPath(row: row, section: 0) //Create the indexpath to get the cell
            let cell = self.tableViewPhieuXuatTam.cellForRow(at:indexPath as IndexPath) as? PhieuXuatTamTableViewCell
            if cell?.buttonChuyenPhieu.isSelected == true {
                //Tạo 1 list id được chọn để gửi.
                listIdPhieuXuatTam.append(Int(cell!.labelId.text!)!)
            }
            row += 1
        }
        //Chuyển từ array Int to string
        for j in listIdPhieuXuatTam {
            if listIdPhieuXuatTamString.isEmpty {
                listIdPhieuXuatTamString = listIdPhieuXuatTamString + "\(j)"
            }else {
                listIdPhieuXuatTamString = listIdPhieuXuatTamString + "," + "\(j)"
            }
        }
        chuyenPhieu()
//        print(listIdPhieuXuatTamString)
        self.listIdPhieuXuatTamString = ""

    }
    func chuyenPhieu(){
        let headers: HTTPHeaders = [
            "Content-Type": GenericsStatic.CONTENT_TYPE,
            "database": GenericsStatic.CHI_NHANH,
            "token": GenericsStatic.TOKEN
        ]
        let params: [String: Any] = [
            "cm": "chuyenphieuxuattam",
            "dt": listIdPhieuXuatTamString
        ]
        let url = GenericsStatic.URL + "phieuxuattam"
        Alamofire.request(url,method: .post,parameters: params,headers: headers).responseJSON{(response) in
            switch response.result {
            case .success(let value):
                // Handler Login Successecode(Customer.self, from: jsonData!)
                let rs = value as? NSDictionary
                let error = rs!["err"]! as? Int
                if error == 0 {
                    let alert = UIAlertController(title: "Thông báo", message: "Thành công!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                        self.tableViewPhieuXuatTam.reloadData()
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Thông báo", message: "Thất bại!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                        self.tableViewPhieuXuatTam.reloadData()
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
