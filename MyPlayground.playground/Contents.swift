import UIKit
import Kanna
import Alamofire

var str = "Hello, playground"

struct Login: Encodable {
    let email: String
    let password: String
}

struct Parameters: Encodable {
    let word: String
    let genre: Int
    let title: Int = 1
}

let parameters = Parameters(word: "おっぱい",genre: 102)

let login = Login(email: "test@test.test", password: "testPassword")

AF.request("https://api.syosetu.com/novelapi/api/", method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).response { response in
    debugPrint(response)
    
}

