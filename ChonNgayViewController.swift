import UIKit

class ChonNgayViewController: UIViewController {

   
    @IBOutlet weak var pickerChonNgay: UIDatePicker!
    @IBOutlet weak var buttonOKChonNgay: UIButton!
    
    var didSendData: ((String)-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tapOKButtonChonNgay (_ sender: Any){
        dismiss(animated: true)
    }
}
