//
//  CycleMode.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import Foundation

enum CycleMode: Int, Codable {
  case none = 0
  case loopToLongestVideo = 1
  case loopToShortestVideo = 2
  case loopToLongestAudio = 3
  case loopToShortestAudio = 4
}
