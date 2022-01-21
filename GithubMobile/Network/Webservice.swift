//
//  Webservice.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/17/22.
//

import Foundation

/// A web service class
class Webservice: WebserviceProtocol {
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    /// A function to fetch a given user's repos
    /// - Parameters:
    ///   - username: a user's github username
    ///   - completionHandler: fetch response
    func fetchUserRepos(username: String,
                        completionHandler: @escaping (QueryError?, FetchUserReposResponseModel?) -> ()) {
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
                    let repos = try JSONDecoder().decode([UserRepo].self, from: responseData)
                    let fetchUserReposResponseModel = FetchUserReposResponseModel(userRepos: repos)
                    completionHandler(nil, fetchUserReposResponseModel)
                    return;
                } catch {
                    completionHandler(.jsonParse, nil)
                    return;
                }
            }
        }
        dataTask.resume()
    }
    
    
    /// A function to fetch a user's commits on a repo
    /// - Parameters:
    ///   - username: name of the github user
    ///   - repoName: name of the repo
    ///   - completionHandler: fetch response
    func fetchRepoCommits(username: String, repoName: String,
                          completionHandler: @escaping (QueryError?, FetchRepoCommitsResponseModel?) -> ()) {
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
                    let commits = try JSONDecoder().decode([Commit].self, from: responseData)
                    let fetchRepoCommitsResponseModel = FetchRepoCommitsResponseModel(repoCommits: commits)
                    completionHandler(nil, fetchRepoCommitsResponseModel)
                    return;
                } catch {
                    completionHandler(.jsonParse, nil)
                    return;
                }
            }
        }
        dataTask.resume()
    }
}
