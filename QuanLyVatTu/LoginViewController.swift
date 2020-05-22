import UIKit
import Alamofire


class LoginViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    @IBOutlet weak var labelLoginError: UILabel!
    @IBOutlet weak var labelChonChiNhanh: UIButton!
    var chiNhanh: [String] = ["Hồ Chí Minh","Bắc Ninh","Bình Dương"]
    
    @IBOutlet var viewChonChiNhanh: UIView!
    @IBOutlet weak var pickerChonChiNhanh: UIPickerView!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelChonChiNhanh.setTitle("Hồ Chí Minh", for: .normal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //Hidden keyboard
    @objc func viewTapped(gestureRecognizer: UIGestureRecognizer){
        view.endEditing(true)
    }
    
//Xử lý chọn chi nhánh
    func handleChonChiNhanh() -> String {
        if labelChonChiNhanh.titleLabel?.text == "Hồ Chí Minh" {
            return "HCM"
        }
        if labelChonChiNhanh.titleLabel?.text == "Bình Dương" {
            return "BD"
        }
        else {
            return "BN"
        }
    }
    @IBAction func login(_ sender: Any) {
        GenericsStatic.CHI_NHANH = handleChonChiNhanh()
        GenericsStatic.CONTENT_TYPE = "application/x-www-form-urlencoded"
        GenericsStatic.TOKEN = "123"
//        let headers: HTTPHeaders = [
//            "Content-Type": GenericsStatic.CONTENT_TYPE,
//            "database": GenericsStatic.CHI_NHANH,
//        ]
//        let params: [String: Any] = [
//            "user": txtUsername.text!,
//            "pass": txtPassword.text!
//        ]
//        let url = GenericsStatic.URL + "login"
//        Alamofire.request(url,method: .post,parameters: params,headers: headers).responseJSON{(response) in
//            switch response.result {
//            case .success(let value):
//                // Handler Login Successecode(Customer.self, from: jsonData!)
//                let rs = value as? NSDictionary
//                let error = rs!["err"]! as? Int
//                if error == 0 {
//                    self.labelLoginError.text = ""
//                    // Tạo storyboard
//                    let sb = UIStoryboard.init(name: "Main", bundle: nil)
//                    // Tạo màn hình
//                    let indexScreen = sb.instantiateViewController(withIdentifier: "STIndex")
//                    //Push màn hình lên
//                    self.navigationController?.pushViewController(indexScreen, animated: true)
////                    self.sendMessageZalo()
//                }else{
//                    self.labelLoginError.text = "Sai tên đăng nhập hoặc mật khẩu."
//                }
//            case .failure(let error):
//                // Handler Login Failure
//                debugPrint(error)
//            }
//        }
//        //Test bỏ qua login
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
//        // Tạo màn hình
        let indexScreen = sb.instantiateViewController(withIdentifier: "STIndex")
//        //Push màn hình lên
        self.navigationController?.pushViewController(indexScreen, animated: true)
    }
    
    // Chức năng chọn chi nhánh
    @IBAction func buttonOKChonChiNhanh(_ sender: Any) {
        self.viewChonChiNhanh.removeFromSuperview()
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.labelChonChiNhanh.setTitle(chiNhanh[row], for: .normal)
    }
    @IBAction func tapChonChiNhanh(_ sender: Any) {
        self.view.addSubview(viewChonChiNhanh)
        viewChonChiNhanh.center = self.view.center
        self.pickerChonChiNhanh.setValue(UIColor.white, forKey: "textColor")
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return chiNhanh.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return chiNhanh[row]
    }
}

