//
//  ThongTinPhieuNhapTableViewCell.swift
//  QuanLyVatTu
//
//  Created by Macintosh HD on 4/13/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import UIKit

class ThongTinPhieuNhapTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageThongTinPhieuNhapTam: UIImageView!
    @IBOutlet weak var labelTenVatTu: UILabel!
    @IBOutlet weak var labelSoLuongChungTu: UILabel!
    @IBOutlet weak var labelSoLuongThucTe: UILabel!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var buttonView: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillData(_ data: ChiTietPhieuNhapTam){
        self.imageThongTinPhieuNhapTam.image = UIImage.init(named: "chitietphieunhap")
        self.labelTenVatTu.text = data.tenVatTu
        self.labelSoLuongChungTu.text = String(describing: data.soluongChungtu)
        self.labelSoLuongThucTe.text = String(describing: data.soluongThucte)
        if #available(iOS 13.0, *) {
            self.buttonView.setImage(UIImage(systemName: "eye"), for: .normal)
            self.buttonAdd.setImage(UIImage(systemName: "plus"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
