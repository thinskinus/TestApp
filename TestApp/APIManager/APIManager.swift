//
//  APIManager.swift
//  TestApp
//
//  Created by ElenaD on 11/19/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import Foundation
import VKSdkFramework

protocol AuthDelegate: class {
    func keepToken(_ token: VKAccessToken)
}

class APIManager {

    static let shared: APIManager = APIManager()

    private init() {}

    var userToken: VKAccessToken?

    private func params() -> [AnyHashable: Any] {
        if let accessToken = userToken?.accessToken {
            return ["access_token" : accessToken]
        } else {
            return [:]
        }
    }

    func requestUserData(completion: @escaping (User?, [User]) -> Void) {
        var params = self.params()
        params["fields"] = ["photo_id", "photo_50", "nickname"]

        if let request = VKApi.users()?.get(params) {
            request.execute(resultBlock: { [unowned self] response in
                if let userjson = (response?.json as? [[String: Any]])?.first {
                    InMemoryCacheManager.shared.authorizedUser = User(from: userjson)
                    self.requestList(completion: completion)
                }
            }) { error in
                print ("error accessing user data \(error?.localizedDescription ?? "no data")")
            }
        }
    }

    func requestList(completion: @escaping (User?, [User]) -> Void) {
        if let friendsRequest = VKApi.friends()?.get(params()) {
            friendsRequest.execute(resultBlock: { [unowned self] response in
                if let data = (response?.json as? [String: Any]) {
                    if let ids = data["items"] as? [Int] {
                        self.requestFriendsData(user_ids: ids, completion: completion)
                    }
                }
            }) { error in
                print ("error accessing user data \(error?.localizedDescription ?? "no data")")
            }
        }
    }

    func requestFriendsData(user_ids: [Int], completion: @escaping (User?, [User]) -> Void) {
        var params = self.params()
        params["user_ids"] = user_ids
        params["fields"] = ["photo_id", "photo_50", "photo_200_orig", "nickname"]

        if let request = VKApi.users()?.get(params) {
            request.execute(resultBlock: { response in
                var friends: [User] = []
                let currentFriends = InMemoryCacheManager.shared.friends
                if let usersJSON = (response?.json as? [[String: Any]]) {
                    for item in usersJSON {
                        let parsedUser = User(from: item)
                        if let existedUser = currentFriends.first(where: {$0.id == parsedUser.id}) {
                            parsedUser.replacingImage = existedUser.replacingImage
                        }
                        friends.append(parsedUser)
                    }
                }
                InMemoryCacheManager.shared.friends = friends
                completion(InMemoryCacheManager.shared.authorizedUser, friends)
            }) { error in
                print ("error accessing user data \(error?.localizedDescription ?? "no data")")
            }
        }
    }

    func startDownloadTask(with url: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url,
                                   completionHandler: { (data, response, error) -> Void in
                                    guard let httpURLResponse = response as? HTTPURLResponse,
                                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                                        let data = data,
                                        let image = UIImage(data: data),
                                        error == nil,
                                        httpURLResponse.statusCode == 200
                                        else {
                                            return
                                    }
                                    completion(image)

        }).resume()
    }
}

extension APIManager: AuthDelegate {
    func keepToken(_ token: VKAccessToken) {
        userToken = token
    }
}
