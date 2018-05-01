
import UIKit

class SearchMovie: NSObject {
    
    func search(name: String, page:Int, completion:@escaping (MovieResults, MovieError?)->Void) {
        let apiClient = NetworkDispatcher(name: "search", host: Constants.Api.searchHost);
        let req = UserRequests.search(name: name, page:"\(page)");
        apiClient.execute(request: req) { (result) in
            switch result {
            case .success(let data):
                if let jsonData = data {
                    let decoder = JSONDecoder()
                    do {
                        let movieResults  = try decoder.decode(MovieResults.self, from: jsonData)
                        completion(movieResults,nil)
                    }
                    catch let error {
                        print(error)
                        completion(MovieResults(),MovieError.InvalidData)
                    }
                }
            case .failure(let error):
                print(error)
                completion(MovieResults(),MovieError.NetworkError);
            }
        }
    }
}
