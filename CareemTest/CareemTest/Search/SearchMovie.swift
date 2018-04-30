
import UIKit

class SearchMovie: NSObject {
    func search(name: String, page:Int, completion:@escaping (MovieResults)->Void) {
       // http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=batman&page=1
        let apiClient = NetworkDispatcher(name: "search", host: "http://api.themoviedb.org");
        
        print("what is the name and page now is >>>>> ,\(name) and \(page)")
        let req = UserRequests.search(name: name, page:"\(page)");
        apiClient.execute(request: req) { (result) in
            switch result {
            case .success(let data):
                if let jsonData = data {
                    let decoder = JSONDecoder()
                    do {
                        let movieResults  = try decoder.decode(MovieResults.self, from: jsonData)
                        completion(movieResults)
                    }
                    catch{
                        print("error in json serialization")
                        completion(MovieResults())
                    }
                }
            case .failure(let error):
                completion(MovieResults());
            }
            
            
        }
    }
}
