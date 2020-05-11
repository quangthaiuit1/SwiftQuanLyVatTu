import Foundation

struct XuatLoHang: Codable {
    var idlohang: Int
    var ngaynhap: String
    var malh: String
    var sllohang: Double
    var ngayhethan: String
    init(_ id: Int, _ malh: String,_ ngaynhap: String,_ ngayhethan: String,_ sllohang: Double) {
        self.idlohang = id
        self.ngaynhap = ngaynhap
        self.ngayhethan = ngayhethan
        self.malh = malh
        self.sllohang = sllohang
    }
}

struct PhieuXuatTam {
    var id: Int
    var ngay: String
    var maphieu: String
    var kho: String
    var daxuat: Bool
    var noinhan: String
    
    init(_ id: Int,_ ngay: String, _ maphieu: String,_ kho: String,_ daxuat: Bool,_ noinhan: String) {
        self.id = id
        self.ngay = ngay
        self.maphieu = maphieu
        self.kho = kho
        self.daxuat = daxuat
        self.noinhan = noinhan
    }
}


struct PhieuNhapTam: Codable {
    var id: Int
    var ngay: String
    var maphieu: String
    var loaiphieu: String
    var dataolohang: Bool
    var nhacungcap: String
    var kiemtra: Bool
    
    init(_ id: Int,_ ngay: String, _ maphieu: String,_ loaiphieu: String,_ dataolohang: Bool,_ kiemtra: Bool ,_ nhacungcap: String) {
        self.id = id
        self.ngay = ngay
        self.maphieu = maphieu
        self.loaiphieu = loaiphieu
        self.dataolohang = dataolohang
        self.kiemtra = kiemtra
        self.nhacungcap = nhacungcap
    }
}

struct ChiTietPXT: Codable {
    var id: Int
    var maVatTu: String
    var tenVatTu: String
    var soluongYeuCau: Double
    var soluongThucXuat: Double
    
    var loHangXuats: [XuatLoHang]
    
    init(_ id: Int,_ maVatTu: String, _ tenVatTu: String,_ soluongYeuCau: Double,_ soluongThucXuat: Double,_ loHangXuats: [XuatLoHang]) {
        self.id = id
        self.maVatTu = maVatTu
        self.tenVatTu = tenVatTu
        self.soluongYeuCau = soluongYeuCau
        self.soluongThucXuat = soluongThucXuat
        self.loHangXuats = loHangXuats
    }
}

// Json Phiếu xuất tạm
struct ChiTietPhieuXuatTamSend: Codable {
    //Phiếu xuất tạm
    var id: Int
    var ngay: String
    var maphieu: String
    var kho: String
    var daxuat: Bool
    var noinhan: String
    
    var phieuXuatTamDetails: [ChiTietPXT]
    
    init(_ id: Int,_ ngay: String, _ maphieu: String,_ kho: String,_ daxuat: Bool,_ noinhan: String,_ phieuXuatTamDetails: [ChiTietPXT]) {
        self.id = id
        self.ngay = ngay
        self.maphieu = maphieu
        self.kho = kho
        self.daxuat = daxuat
        self.noinhan = noinhan
        
        self.phieuXuatTamDetails = phieuXuatTamDetails
    }
}


struct LoHang: Codable {
    var id: Int
    var malh: String
    var ngaynhap: String
    var ngayhethan: String
    var lhdat: Bool
    var sllohang: Double
    
    init(_ id: Int,_ malh: String, _ ngaynhap: String, _ ngayhethan: String,_ lhdat: Bool, _ sllohang: Double) {
        self.id = id
        self.malh = malh
        self.ngaynhap = ngaynhap
        self.ngayhethan = ngayhethan
        self.lhdat = lhdat
        self.sllohang = sllohang
    }
}

struct ChiTietPhieuNhapTam: Codable {
    var id: Int
    var maVatTu: String
    var tenVatTu: String
    var soluongChungtu: Double
    var soluongThucte: Double
    
    var loHangs: [LoHang]
    
    init(_ id: Int,_ maVatTu: String, _ tenVatTu: String,_ soluongChungtu: Double,_ soluongThucte: Double,_ loHangs: [LoHang]) {
        self.id = id
        self.maVatTu = maVatTu
        self.tenVatTu = tenVatTu
        self.soluongChungtu = soluongChungtu
        self.soluongThucte = soluongThucte
        self.loHangs = loHangs
    }
}

// Json phiếu nhập tạm

struct ChiTietPhieuNhapTamSend: Codable{
    //Phieu nhập tạm
    var id: Int
    var ngay: String
    var maphieu: String
    var loaiphieu: String
    var dataolohang: Bool
    var nhacungcap: String
    var kiemtra: Bool
    
    var phieuNhapTamDetails: [ChiTietPhieuNhapTamAndLoHang]
    
    init(_ id: Int,_ ngay: String, _ maphieu: String,_ loaiphieu: String,_ dataolohang: Bool,_ kiemtra: Bool ,_ nhacungcap: String, _ phieuNhapTamDetails: [ChiTietPhieuNhapTamAndLoHang]) {
        
        self.id = id
        self.ngay = ngay
        self.maphieu = maphieu
        self.loaiphieu = loaiphieu
        self.dataolohang = dataolohang
        self.kiemtra = kiemtra
        self.nhacungcap = nhacungcap
        
        self.phieuNhapTamDetails = phieuNhapTamDetails
    }
}
struct ChiTietPhieuNhapTamAndLoHang: Codable {
    //Chi tiết phiếu nhập
    var id: Int
    var mavt: String
    var tenvt: String
    var slchungtu: Double
    var slthucte: Double
    
    var loHangs: [LoHang]
    init(_ id: Int,_ maVatTu: String, _ tenVatTu: String,_ soluongChungtu: Double,_ soluongThucte: Double, _ lohangs: [LoHang]) {
        self.id = id
        self.mavt = maVatTu
        self.tenvt = tenVatTu
        self.slchungtu = soluongChungtu
        self.slthucte = soluongThucte
        
        self.loHangs = lohangs
    }
}
