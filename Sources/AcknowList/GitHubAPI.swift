//
// GitHubAPI.swift
//
// Copyright (c) 2015-2025 Vincent Tourraine (https://www.vtourraine.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// An object that interacts with the GitHub API.
open class GitHubAPI {

    /**
     Gets the repository license.
     - Parameters:
        - repository: The GitHub URL for the repository. For example: `https://github.com/vtourraine/AcknowList.git`
        - completionHandler: The completion handler to call when the load request is complete. This handler is executed on the main queue. It takes a `Result` parameter, with either the body of the license, or an error object that indicates why the request failed.
     */
    @discardableResult public static func getLicense(for repository: URL, completionHandler: @escaping (Result<String, Error>) -> Void) -> URLSessionDataTask {
        // GitHub API documentation
        // https://docs.github.com/en/rest/licenses/licenses#get-the-license-for-a-repository

        let request = getLicenseRequest(for: repository)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if (response as? HTTPURLResponse)?.statusCode == 200,
                   let data,
                   let text = String(data: data, encoding: .utf8) {
                    completionHandler(.success(text))
                }
                else {
                    completionHandler(.failure(error ?? URLError(URLError.Code.unknown)))
                }
            }
        }

        task.resume()
        return task
    }

    /**
     Returns a Boolean value indicating whether a URL is a valid GitHub repository URL.
     - Parameter repository: The GitHub URL for the repository. For example: `https://github.com/vtourraine/AcknowList.git`
     */
    public static func isGitHubRepository(_ repository: URL) -> Bool {
        return repository.absoluteString.hasPrefix("https://github.com/")
    }

    internal static func getLicenseRequest(for repository: URL) -> URLRequest {
        let path = pathWithoutExtension(for: repository)
        let url  = "https://api.github.com/repos\(path)/license"
        var request = URLRequest(url: URL(string: url)!)
        request.allHTTPHeaderFields = [
            "Accept": "application/vnd.github.raw",
            "X-GitHub-Api-Version": "2022-11-28"]
        return request
    }

    internal static func pathWithoutExtension(for repository: URL) -> String {
        return repository.path.replacingOccurrences(of: ".git", with: "")
    }
}
