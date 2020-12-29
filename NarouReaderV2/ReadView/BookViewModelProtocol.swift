import Combine
import Foundation
import Alamofire

public enum BookCommand {
    case showSnackbar(String)
}

protocol BookViewModelProtocol {
    var command: PassthroughSubject<BookCommand, Never> { get }
    var novels: CurrentValueSubject<[Novel], Never> { get }
    
    func getNovels(completion: @escaping ([Novel]) -> Void)
    func loadNovels()
}

extension BookViewModelProtocol {
    func getNovels(completion: @escaping ([Novel]) -> Void) {
        if UserDefaults.standard.stringArray(forKey: "novels") != [] {
            let novelList = UserDefaults.standard.stringArray(forKey: "novels")?.joined(separator: "-")
            let decoder = JSONDecoder()
            let parameter = ["ncode": novelList,"out":"json"]
            
            AF.request("https://api.syosetu.com/novelapi/api/", method: .get, parameters: parameter, encoder: URLEncodedFormParameterEncoder.default).responseString { response in
                
                switch response.result {
                case .success:
                    
                    do {
                        let narouContainer = try decoder.decode(NarouContainer.self, from: Data(response.value!.utf8))
                        var novels: [Novel] = []
                        let list = UserDefaults.standard.stringArray(forKey: "novels")!
                        for novel in list {
                            novels.append(contentsOf: narouContainer.novels.filter{ $0.ncode == novel })
                        }
                        completion(novels)
                    } catch let error {
                        print("Error = \(error)")
                    }
                case .failure:
                    print("failure")
                }
            }
        }
    }
}
