import UIKit

class XuatLoHangTableViewCell: UITableViewCell {

    @IBOutlet weak var imageXuatLoHang: UIImageView!
    @IBOutlet weak var labelNgayNhap: UILabel!
    @IBOutlet weak var labelSoLuong: UILabel!
    @IBOutlet weak var labelMaLH: UILabel!
    @IBOutlet weak var textFieldSoLuong: UITextField!
    @IBOutlet weak var buttonOkXuat: UIButton!
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var labelNgayHetHan: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillData(_ data: XuatLoHang){
        self.imageXuatLoHang.image = UIImage.init(named: "BAT")
        self.labelMaLH.text = data.malh
        self.labelNgayNhap.text = data.ngaynhap
        self.labelSoLuong.text = String(describing: data.sllohang)
        self.labelId.text = String(describing: data.idlohang)
        self.labelNgayHetHan.text = data.ngayhethan
//        self.buttonOkXuat.setImage(UIImage.init(named: "UnCheckbox"), for: .normal)
//        self.buttonOkXuat.setImage(UIImage.init(named: "Checkbox"), for: .selected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
