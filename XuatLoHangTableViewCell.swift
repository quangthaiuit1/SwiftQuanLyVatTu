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
    
    var delegateCell : XuatLohangTableViewCellDelegate?
    
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
        self.buttonOkXuat.addTarget(self, action: #selector(buttonOkTapped(_:)), for: .touchUpInside)
        self.textFieldSoLuong.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingDidEnd)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func textFieldEditingDidChange (_ sender: Any){
        if delegateCell != nil {
            self.delegateCell?.passCellToTTPX(self)
        }
    }
    
    @IBAction func buttonOkTapped (_ sender: UIButton) {
        if self.buttonOkXuat.isSelected {
            self.buttonOkXuat.isSelected = false
        }
        else {
            self.buttonOkXuat.isSelected = true
        }
        if delegateCell != nil {
            self.delegateCell?.passCellToTTPX(self)
        }
    }
    
}
protocol XuatLohangTableViewCellDelegate: AnyObject {
    func passCellToTTPX(_ XuatLoHangTableViewCell: XuatLoHangTableViewCell)
}
