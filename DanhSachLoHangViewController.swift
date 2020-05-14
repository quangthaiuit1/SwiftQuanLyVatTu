import UIKit
import Alamofire

class DanhSachLoHangViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var lohangs = [LoHang]()
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
