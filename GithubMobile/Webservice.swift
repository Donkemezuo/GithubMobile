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
        guard !username.isEmpty else {
            completionHandler(.invalidUsername, nil)
            return;
        }
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
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -999
                      completionHandler(.badStatusCode(statusCode: String(statusCode)), nil)
                      return;
                  }
            if let responseData = responseData {
                do {
                    let fetchUserReposResponseModel = try JSONDecoder().decode(FetchUserReposResponseModel.self, from: responseData)
                    completionHandler(nil, fetchUserReposResponseModel)
                    return;
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.jsonParse, nil)
                    return;
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchRepoCommits(username: String, repoName: String, completionHandler: @escaping (QueryErrors?, FetchRepoCommitsResponseModel?) -> ()) {
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
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -999
                      completionHandler(.badStatusCode(statusCode: String(statusCode)), nil)
                      return;
                  }
            if let responseData = responseData {
                do {
                    let fetchRepoCommitsResponseModel = try JSONDecoder().decode(FetchRepoCommitsResponseModel.self, from: responseData)
                    completionHandler(nil, fetchRepoCommitsResponseModel)
                    return;
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.jsonParse, nil)
                    return;
                }
            }
        }
        dataTask.resume()
    }
}
