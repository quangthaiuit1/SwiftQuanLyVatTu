import UIKit

class IndexViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var viewSearchDate: UIView!
    @IBOutlet weak var textFieldTuNgay: UITextField!
    @IBOutlet weak var textFieldDenNgay: UITextField!
    
    @IBOutlet weak var btnPhieuNhap: UIButton!
    
    private var datePickerTuNgay: UIDatePicker?
    private var datePickerDenNgay: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = ("Chương trình vật tư")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchDate))
        //init from date to date
        DispatchQueue.main.async {
            GenericsStatic.DEN_NGAY = self.getCurrentDateString()
            GenericsStatic.TU_NGAY = self.getLast7Days()
        }
        textFieldTuNgay.delegate = self
//        //Chon ngay
        datePickerTuNgay = UIDatePicker()
        datePickerDenNgay = UIDatePicker()
        datePickerTuNgay?.datePickerMode = .date
        datePickerTuNgay?.addTarget(self, action: #selector(IndexViewController.dateChangedTuNgay(datePicker:)), for: .valueChanged)
        datePickerDenNgay?.datePickerMode = .date
        datePickerDenNgay?.addTarget(self, action: #selector(IndexViewController.dateChangedDenNgay(datePicker:)), for: .valueChanged)
        textFieldTuNgay.inputView = datePickerTuNgay
        textFieldDenNgay.inputView = datePickerDenNgay
        //Xử lý ẩn popup datePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    //Set default current date for textfield date
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        if textFieldTuNgay.text!.isEmpty {
            textFieldTuNgay.text = dateFormatter.string(from: Date())
        }
        if  textFieldDenNgay.text!.isEmpty {
             textFieldDenNgay.text = dateFormatter.string(from: Date())
        }
        return true
    }
    //Get current Date
    func getCurrentDateString() -> String {
        let dateString = GenericsStatic.getDateFormatter().string(from: GenericsStatic.getCurrentDate())
        return dateString
    }
    //Get last 7 days starting from today
    func getLast7Days() -> String{
        var dateComponent = DateComponents()
        dateComponent.day = -200
        let last7DaysTemp = Calendar.current.date(byAdding: dateComponent, to: GenericsStatic.getCurrentDate())
        let last7Days = GenericsStatic.getDateFormatter().string(from: last7DaysTemp!)
        return last7Days
    }
    
    //Chon ngay nhap
    @objc func dateChangedTuNgay(datePicker: UIDatePicker){
        textFieldTuNgay.text = GenericsStatic.getDateFormatter().string(from: datePicker.date)
        view.endEditing(true)
    }
    @objc func dateChangedDenNgay(datePicker: UIDatePicker){
        textFieldDenNgay.text = GenericsStatic.getDateFormatter().string(from: datePicker.date)
        view.endEditing(true)
    }
    //Bỏ popup chọn ngày
    @objc func viewTapped(gestureRecognizer: UIGestureRecognizer){
        view.endEditing(true)
    }
    //Xử lý tìm kiếm theo ngày
    @objc func handleSearchDate() {
        self.view.addSubview(viewSearchDate)
        viewSearchDate.center = self.view.center
    }
    @IBAction func chonPhieuNhapTam(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let phieuNhapTamScreen = sb.instantiateViewController(withIdentifier: "STPhieuNhapTam") as! PhieuNhapTamViewController
        self.navigationController?.pushViewController(phieuNhapTamScreen, animated: true)
    }
    @IBAction func chonPhieuXuatTam(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let phieuXuatTamScreen = sb.instantiateViewController(withIdentifier: "STPhieuXuatTam")
        self.navigationController?.pushViewController(phieuXuatTamScreen, animated: true)
    }
    
    @IBAction func buttonDongYTapped(_ sender: Any) {
        GenericsStatic.TU_NGAY = textFieldTuNgay.text!
        GenericsStatic.DEN_NGAY = textFieldDenNgay.text!
        viewSearchDate.removeFromSuperview()
    }
}
