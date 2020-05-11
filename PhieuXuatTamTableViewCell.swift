//
//  PhieuXuatTamTableViewCell.swift
//  QuanLyVatTu
//
//  Created by Macintosh HD on 4/20/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit

class PhieuXuatTamTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imagePhieuXuatTam: UIImageView!
    @IBOutlet weak var labelNoiNhan: UILabel!
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var labelMaPhieu: UILabel!
    @IBOutlet weak var labelKho: UILabel!
    @IBOutlet weak var buttonDaXuat: UIButton!
    @IBOutlet weak var buttonChuyenPhieu: UIButton!
    @IBOutlet weak var labelNgay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillData(_ data: PhieuXuatTam){
        self.labelId.text = String(data.id)
        self.imagePhieuXuatTam.image = UIImage.init(named: "phieuxuat")
        self.labelMaPhieu.text = data.maphieu
        self.labelKho.text = data.kho
        self.labelNgay.text = data.ngay
        self.buttonDaXuat.setImage(UIImage.init(named: "UnCheckbox"), for: .normal)
        self.buttonDaXuat.setImage(UIImage.init(named: "Checkbox"), for: .selected)
        if data.daxuat {
            self.buttonDaXuat.isSelected = true
        }else {
            self.buttonDaXuat.isSelected = false
        }
        self.buttonChuyenPhieu.setImage(UIImage.init(named: "UnCheckbox"), for: .normal)
        self.buttonChuyenPhieu.setImage(UIImage.init(named: "Checkbox"), for: .selected)
        self.buttonChuyenPhieu.isSelected = false
        self.labelNoiNhan.text = data.noinhan
    }
    
}
