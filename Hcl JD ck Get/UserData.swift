//
//  UserData.swift
//  Hcl JD ck Get
//
//  Created by scjtqs on 2022/7/20.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    @Published var landmarks = landmarkData
    @Published var profile = Profile.default
}
