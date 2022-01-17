//
//  Webservice.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/17/22.
//

import Foundation

class Webservice: WebserviceProtocol {
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchUserRepos(username: String, completionHandler: @escaping (QueryErrors?, FetchUserReposResponseModel?) -> ()) {
        let endpointString = QueryEndPoint.userRepos(username: username).endPointURL
        guard let reposURL = URL(string: endpointString)
        else {
            completionHandler(.invalidURL(urlString: endpointString), nil)
            return;
        }
        let dataTask = urlSession.dataTask(with: reposURL) { responseData, response, error in
            if let error = error {
                completionHandler(.failedRequest(destination: error.localizedDescription), nil)
                return;
            } else if let responseData = responseData {
                do {
                    let fetchUserReposResponseModel = try JSONDecoder().decode(FetchUserReposResponseModel.self, from: responseData)
                    completionHandler(nil, fetchUserReposResponseModel)
                } catch {
                    completionHandler(.jsonParse, nil)
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchRepoCommits(username: String, repoName: String, completionHandler: @escaping (QueryErrors?, Data?) -> ()) {
        let endpointString = QueryEndPoint.repoCommits(username: username, repoName: repoName).endPointURL
        guard let commitsURL = URL(string: endpointString)
        else {
            completionHandler(.invalidURL(urlString: endpointString), nil)
            return;
        }
        let dataTask = urlSession.dataTask(with: commitsURL) { responseData, response, error in
            if let error = error {
                completionHandler(.failedRequest(destination: error.localizedDescription), nil)
                return;
            } else if let responseData = responseData {
                completionHandler(nil, responseData)
            }
        }
        dataTask.resume()
    }
}
