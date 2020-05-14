import UIKit

class TTPhieuXuatTamTableViewCell: UITableViewCell {

    @IBOutlet weak var imageChiTietPXT: UIImageView!
    @IBOutlet weak var labelTenVT: UILabel!
    @IBOutlet weak var labelSoLuongYeuCau: UILabel!
    @IBOutlet weak var labelSoLuongThucXuat: UILabel!
    @IBOutlet weak var buttonEye: UIButton!
    @IBOutlet weak var buttonPencil: UIButton!
          
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func fillData(_ data: ChiTietPXT){
        self.imageChiTietPXT.image = UIImage.init(named: "phieuxuat")
        self.labelTenVT.text = data.tenVatTu
        self.labelSoLuongYeuCau.text = String(data.soluongYeuCau)
        self.labelSoLuongThucXuat.text = String(data.soluongThucXuat)
        if #available(iOS 13.0, *) {
            self.buttonEye.setImage(UIImage(systemName: "eye"), for: .normal)
            self.buttonPencil.setImage(UIImage(systemName: "pencil"), for: .normal)
        } else {
            self.buttonEye.setImage(UIImage.init(named: "view24"), for: .normal)
            self.buttonPencil.setImage(UIImage.init(named: "pencil16_1"), for: .normal)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
