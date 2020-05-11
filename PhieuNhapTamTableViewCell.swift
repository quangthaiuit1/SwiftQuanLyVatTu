//
//  PhieuNhapTamTableViewCell.swift
//  QuanLyVatTu
//
//  Created by Macintosh HD on 4/7/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit

class PhieuNhapTamTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imagePhieuNhapTam: UIImageView!
    
    @IBOutlet weak var buttonDatao: UIButton!
    @IBOutlet weak var labelNhaCungCap: UILabel!
//    @IBOutlet weak var buttonChuyenPhieu: UIButton!
    
    @IBOutlet weak var buttonKiemTra: UIButton!
    
    @IBOutlet weak var buttonChuyenPhieu: UIButton!
    
    @IBOutlet weak var labelId: UILabel!
    
    @IBOutlet weak var labelMaPhieu: UILabel!
    
    @IBOutlet weak var labelNgayNhap: UILabel!
    @IBOutlet weak var labelLoaiPhieu: UILabel!
    
    @IBOutlet weak var btnDaTao: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillData(_ data: PhieuNhapTam){
        self.labelId.text = String(describing: data.id)
        self.imagePhieuNhapTam.image = UIImage.init(named: "phieunhap")
        self.labelNgayNhap.text = data.ngay
        self.labelMaPhieu.text = data.maphieu
        self.labelLoaiPhieu.text = data.loaiphieu
        self.buttonDatao.setImage(UIImage.init(named: "UnCheckbox"), for: .normal)
        self.buttonDatao.setImage(UIImage.init(named: "Checkbox"), for: .selected)
        if data.dataolohang {
            self.buttonDatao.isSelected = true
        }else {
            self.buttonDatao.isSelected = false
        }
        self.buttonKiemTra.setImage(UIImage.init(named: "UnCheckbox"), for: .normal)
         self.buttonKiemTra.setImage(UIImage.init(named: "Checkbox"), for: .selected)
        if data.kiemtra {
            self.buttonKiemTra.isSelected = true
        }else {
            self.buttonKiemTra.isSelected = false
        }
        self.buttonChuyenPhieu.setImage(UIImage.init(named: "UnCheckbox"), for: .normal)
        self.buttonChuyenPhieu.setImage(UIImage.init(named: "Checkbox"), for: .selected)
        self.buttonChuyenPhieu.isSelected = false
        self.labelNhaCungCap.text = data.nhacungcap
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
