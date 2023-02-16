//
//  Store.swift
//  Food_Example
//
//  Created by Артур Кулик on 16.02.2023.
//

import Combine
import SwiftUI

typealias Store<State> = CurrentValueSubject<State, Never>
