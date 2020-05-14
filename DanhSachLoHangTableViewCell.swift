import UIKit

class DanhSachLoHangTableViewCell: UITableViewCell {

    @IBOutlet weak var labelMaLH: UILabel!
    @IBOutlet weak var labelNgayNhap: UILabel!
    @IBOutlet weak var labelHetHan: UILabel!
    @IBOutlet weak var labelSoLuong: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func fillData(_ data: LoHang){
        self.labelMaLH.text = data.malh
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
//        formatter.string(from: data.ngaynhap)
        self.labelNgayNhap.text = data.ngaynhap
//        formatter.string(from: data.ngayhethan)
        self.labelHetHan.text = data.ngayhethan
        self.labelSoLuong.text = String(data.sllohang)
        if #available(iOS 13.0, *) {
            self.buttonDelete.setImage(UIImage.init(systemName: "trash.fill"), for: .normal)
        } else {
            self.buttonDelete.setImage(UIImage.init(named: "delete24_1"), for: .normal)
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
    
    }
    
}
