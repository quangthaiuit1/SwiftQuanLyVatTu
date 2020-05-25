import UIKit

class ThemLoHangViewController: UIViewController, UITextFieldDelegate{

    
    @IBOutlet weak var textFieldMaLH: UITextField!
    @IBOutlet weak var textFieldSoLuongNhap: UITextField!
    @IBOutlet weak var textFieldNgayNhap: UITextField!
    @IBOutlet weak var textFieldNgayHetHan: UITextField!
    @IBOutlet weak var imageClose: UIImageView!
    
    private var datePickerNgayNhap: UIDatePicker?
    private var datePickerNgayHetHan: UIDatePicker?
    
    //Biến hứng giá trị để trả về view thông tin phiếu nhập
    var lohangs = [LoHang]()
    var tongSoLuongThucTe = 0.0
    var index: Int?
        
    var receiveData: sendDSLoHangToThongTinPNT?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sử dụng UITexxtFielđelegate
        textFieldNgayNhap.delegate = self
        //Chon ngay
        datePickerNgayNhap = UIDatePicker()
        datePickerNgayHetHan = UIDatePicker()
        self.datePickerNgayNhap?.locale = GenericsStatic.locale
        self.datePickerNgayHetHan?.locale = GenericsStatic.locale
        datePickerNgayNhap?.datePickerMode = .date
        datePickerNgayHetHan?.datePickerMode = .date
        datePickerNgayNhap?.addTarget(self, action: #selector(ThemLoHangViewController.dateChangedNgayNhap(datePicker:)), for: .valueChanged)
        datePickerNgayHetHan?.addTarget(self, action: #selector(ThemLoHangViewController.dateChangedNgayHetHan(datePicker:)), for: .valueChanged)
        textFieldNgayNhap.inputView = datePickerNgayNhap
        textFieldNgayHetHan.inputView = datePickerNgayHetHan
        self.imageClose.image = UIImage.init(named: "close24")
        //Xử lý ẩn popup datePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    //Chon ngay nhap
       @objc func dateChangedNgayNhap(datePicker: UIDatePicker){
        textFieldNgayNhap.text = GenericsStatic.getDateFormatter().string(from: datePicker.date)
           view.endEditing(true)
       }
       @objc func dateChangedNgayHetHan(datePicker: UIDatePicker){
        textFieldNgayHetHan.text = GenericsStatic.getDateFormatter().string(from: datePicker.date)
           view.endEditing(true)
       }
    //Bỏ popup chọn ngày
    @objc func viewTapped(gestureRecognizer: UIGestureRecognizer){
        view.endEditing(true)
    }
    
    //Set default current date for textfield date
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textFieldNgayNhap.text!.isEmpty {
            textFieldNgayNhap.text = GenericsStatic.getDateFormatter().string(from: Date())
        }
        if  textFieldNgayHetHan.text!.isEmpty {
            var dateComponent = DateComponents()
            dateComponent.day = +365
            let last7DaysTemp = Calendar.current.date(byAdding: dateComponent, to: GenericsStatic.getCurrentDate())
            textFieldNgayHetHan.text = GenericsStatic.getDateFormatter().string(from: last7DaysTemp!)
        }
        return true
    }
    
    @IBAction func dismissThemLoHangTapped(_ sender: Any) {
        receiveData?.sendData(DanhSachLohang: self.lohangs, IndexPathClick: self.index!, TongSoLuong: self.tongSoLuongThucTe)
        dismiss(animated: true)
    }
    
    @IBAction func buttonLuuTapped(_ sender: Any) {
        let malh = self.textFieldMaLH.text!
        //        let soluongTemp = self.textFieldSoLuong.text!
        //get date
        let ngaynhapTemp = self.textFieldNgayNhap.text!
        //        let ngayhethanTemp = self.textFieldNgayHetHan.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if ngaynhapTemp != "" {
//            let ngaynhap = dateFormatter.date(from: ngaynhapTemp)!
            let ngayhethanTemp = self.textFieldNgayHetHan.text!
//            let ngayhethan = dateFormatter.date(from: ngayhethanTemp)!
//            print(ngayhethan)
            let soluong = Double(self.textFieldSoLuongNhap.text!)
            self.tongSoLuongThucTe = tongSoLuongThucTe + soluong!
            
            //Id tự động gen nhưng điền số vào để k bị lỗi request
            let lohang = LoHang(123,malh,ngaynhapTemp,ngayhethanTemp,false,soluong!)
            self.lohangs.append(lohang)
            self.textFieldMaLH.text = ""
            self.textFieldNgayNhap.text = ""
            self.textFieldNgayHetHan.text = ""
            self.textFieldSoLuongNhap.text = ""
        }
        else {
            let alert = UIAlertController(title: "Thông báo", message: "Chưa điền đủ thông  .", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                case _ :
                    print("Thái")
                }}))
            self.present(alert, animated: true)
        }
    }
}
//Protocol
protocol sendDSLoHangToThongTinPNT {
    func sendData(DanhSachLohang lohangs: [LoHang], IndexPathClick index: Int, TongSoLuong tongSL: Double)
}
