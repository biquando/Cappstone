//
//  UserData.swift
//  Cappstone
//
//  Created by Quan Do on 4/15/20.
//  Copyright © 2020 Quan Do. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    @Published var searchText = ""
}
