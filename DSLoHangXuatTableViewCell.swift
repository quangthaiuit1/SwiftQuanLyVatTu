import UIKit

class DSLoHangXuatTableViewCell: UITableViewCell {

    @IBOutlet weak var imageXuatLoHang: UIImageView!
    @IBOutlet weak var labelMaLH: UILabel!
    @IBOutlet weak var labelNgayNhap: UILabel!
    @IBOutlet weak var labelHetHan: UILabel!
    @IBOutlet weak var labelSoLuong: UILabel!
    @IBOutlet weak var buttonXoa: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func fillData(_ data: XuatLoHang){
        self.imageXuatLoHang.image = UIImage.init(named: "BAT")
        self.labelMaLH.text = data.malh
        self.labelNgayNhap.text = data.ngaynhap
        self.labelHetHan.text = data.ngayhethan
        self.labelSoLuong.text = String(describing: data.sllohang)
        //        self.buttonOkXuat.setImage(UIImage.init(named: "UnCheckbox"), for: .normal)
        //        self.buttonOkXuat.setImage(UIImage.init(named: "Checkbox"), for: .selected)
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
