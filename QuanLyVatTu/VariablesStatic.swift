import Foundation

class GenericsStatic {
    static var TOKEN = ""
    static var CHI_NHANH = ""
    static var CONTENT_TYPE = ""
    static let URL = "http://lixco.no-ip.org:9790/quanlyvattu-web/api/"
    
    static var TU_NGAY = "09/01/2020"
    static var DEN_NGAY = "09/12/2020"
    
    static func getCurrentDate () -> Date{
        return Date()
    }
    static func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter
    }
}
