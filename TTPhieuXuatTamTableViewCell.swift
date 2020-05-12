//
//  TTPhieuXuatTamTableViewCell.swift
//  QuanLyVatTu
//
//  Created by Macintosh HD on 4/20/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

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
            // Fallback on earlier versions
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
