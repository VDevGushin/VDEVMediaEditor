// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetChallengeEditorFilterQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetChallengeEditorFilter($baseChallengeId: ID!) {
      baseChallenge(id: $baseChallengeId) {
        __typename
        appEditorNeuralFilters {
          __typename
          id
          name
          cover
          stepsFull {
            __typename
            type
            url
            id
            filterId
            neuralConfig {
              __typename
              minPixels
              maxPixels
              allowedDimensions {
                __typename
                width
                height
              }
              dimensionsMultipleOf
            }
          }
        }
        appEditorFilters {
          __typename
          id
          name
          cover
          stepsFull {
            __typename
            type
            url
          }
        }
      }
    }
    """

  public let operationName: String = "GetChallengeEditorFilter"

  public var baseChallengeId: GraphQLID

  public init(baseChallengeId: GraphQLID) {
    self.baseChallengeId = baseChallengeId
  }

  public var variables: GraphQLMap? {
    return ["baseChallengeId": baseChallengeId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("baseChallenge", arguments: ["id": GraphQLVariable("baseChallengeId")], type: .nonNull(.object(BaseChallenge.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(baseChallenge: BaseChallenge) {
      self.init(unsafeResultMap: ["__typename": "Query", "baseChallenge": baseChallenge.resultMap])
    }

    public var baseChallenge: BaseChallenge {
      get {
        return BaseChallenge(unsafeResultMap: resultMap["baseChallenge"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "baseChallenge")
      }
    }

    public struct BaseChallenge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["BaseChallenge"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("appEditorNeuralFilters", type: .nonNull(.list(.nonNull(.object(AppEditorNeuralFilter.selections))))),
          GraphQLField("appEditorFilters", type: .nonNull(.list(.nonNull(.object(AppEditorFilter.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(appEditorNeuralFilters: [AppEditorNeuralFilter], appEditorFilters: [AppEditorFilter]) {
        self.init(unsafeResultMap: ["__typename": "BaseChallenge", "appEditorNeuralFilters": appEditorNeuralFilters.map { (value: AppEditorNeuralFilter) -> ResultMap in value.resultMap }, "appEditorFilters": appEditorFilters.map { (value: AppEditorFilter) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var appEditorNeuralFilters: [AppEditorNeuralFilter] {
        get {
          return (resultMap["appEditorNeuralFilters"] as! [ResultMap]).map { (value: ResultMap) -> AppEditorNeuralFilter in AppEditorNeuralFilter(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: AppEditorNeuralFilter) -> ResultMap in value.resultMap }, forKey: "appEditorNeuralFilters")
        }
      }

      public var appEditorFilters: [AppEditorFilter] {
        get {
          return (resultMap["appEditorFilters"] as! [ResultMap]).map { (value: ResultMap) -> AppEditorFilter in AppEditorFilter(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: AppEditorFilter) -> ResultMap in value.resultMap }, forKey: "appEditorFilters")
        }
      }

      public struct AppEditorNeuralFilter: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EditorFilter"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("cover", type: .scalar(String.self)),
            GraphQLField("stepsFull", type: .nonNull(.list(.nonNull(.object(StepsFull.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, cover: String? = nil, stepsFull: [StepsFull]) {
          self.init(unsafeResultMap: ["__typename": "EditorFilter", "id": id, "name": name, "cover": cover, "stepsFull": stepsFull.map { (value: StepsFull) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var cover: String? {
          get {
            return resultMap["cover"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "cover")
          }
        }

        public var stepsFull: [StepsFull] {
          get {
            return (resultMap["stepsFull"] as! [ResultMap]).map { (value: ResultMap) -> StepsFull in StepsFull(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: StepsFull) -> ResultMap in value.resultMap }, forKey: "stepsFull")
          }
        }

        public struct StepsFull: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EditorFilterStep"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("type", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .scalar(String.self)),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("filterId", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("neuralConfig", type: .object(NeuralConfig.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(type: String, url: String? = nil, id: GraphQLID, filterId: GraphQLID, neuralConfig: NeuralConfig? = nil) {
            self.init(unsafeResultMap: ["__typename": "EditorFilterStep", "type": type, "url": url, "id": id, "filterId": filterId, "neuralConfig": neuralConfig.flatMap { (value: NeuralConfig) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var type: String {
            get {
              return resultMap["type"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
            }
          }

          public var url: String? {
            get {
              return resultMap["url"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var filterId: GraphQLID {
            get {
              return resultMap["filterId"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "filterId")
            }
          }

          public var neuralConfig: NeuralConfig? {
            get {
              return (resultMap["neuralConfig"] as? ResultMap).flatMap { NeuralConfig(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "neuralConfig")
            }
          }

          public struct NeuralConfig: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["AppNeuralFilterConfig"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("minPixels", type: .nonNull(.scalar(Int.self))),
                GraphQLField("maxPixels", type: .nonNull(.scalar(Int.self))),
                GraphQLField("allowedDimensions", type: .list(.nonNull(.object(AllowedDimension.selections)))),
                GraphQLField("dimensionsMultipleOf", type: .nonNull(.scalar(Int.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(minPixels: Int, maxPixels: Int, allowedDimensions: [AllowedDimension]? = nil, dimensionsMultipleOf: Int) {
              self.init(unsafeResultMap: ["__typename": "AppNeuralFilterConfig", "minPixels": minPixels, "maxPixels": maxPixels, "allowedDimensions": allowedDimensions.flatMap { (value: [AllowedDimension]) -> [ResultMap] in value.map { (value: AllowedDimension) -> ResultMap in value.resultMap } }, "dimensionsMultipleOf": dimensionsMultipleOf])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var minPixels: Int {
              get {
                return resultMap["minPixels"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "minPixels")
              }
            }

            public var maxPixels: Int {
              get {
                return resultMap["maxPixels"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "maxPixels")
              }
            }

            public var allowedDimensions: [AllowedDimension]? {
              get {
                return (resultMap["allowedDimensions"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [AllowedDimension] in value.map { (value: ResultMap) -> AllowedDimension in AllowedDimension(unsafeResultMap: value) } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [AllowedDimension]) -> [ResultMap] in value.map { (value: AllowedDimension) -> ResultMap in value.resultMap } }, forKey: "allowedDimensions")
              }
            }

            public var dimensionsMultipleOf: Int {
              get {
                return resultMap["dimensionsMultipleOf"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "dimensionsMultipleOf")
              }
            }

            public struct AllowedDimension: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Dimension"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("width", type: .nonNull(.scalar(Int.self))),
                  GraphQLField("height", type: .nonNull(.scalar(Int.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(width: Int, height: Int) {
                self.init(unsafeResultMap: ["__typename": "Dimension", "width": width, "height": height])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var width: Int {
                get {
                  return resultMap["width"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "width")
                }
              }

              public var height: Int {
                get {
                  return resultMap["height"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "height")
                }
              }
            }
          }
        }
      }

      public struct AppEditorFilter: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EditorFilter"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("cover", type: .scalar(String.self)),
            GraphQLField("stepsFull", type: .nonNull(.list(.nonNull(.object(StepsFull.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, cover: String? = nil, stepsFull: [StepsFull]) {
          self.init(unsafeResultMap: ["__typename": "EditorFilter", "id": id, "name": name, "cover": cover, "stepsFull": stepsFull.map { (value: StepsFull) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var cover: String? {
          get {
            return resultMap["cover"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "cover")
          }
        }

        public var stepsFull: [StepsFull] {
          get {
            return (resultMap["stepsFull"] as! [ResultMap]).map { (value: ResultMap) -> StepsFull in StepsFull(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: StepsFull) -> ResultMap in value.resultMap }, forKey: "stepsFull")
          }
        }

        public struct StepsFull: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EditorFilterStep"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("type", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(type: String, url: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "EditorFilterStep", "type": type, "url": url])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var type: String {
            get {
              return resultMap["type"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
            }
          }

          public var url: String? {
            get {
              return resultMap["url"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }
        }
      }
    }
  }
}

public final class GetChallengeEditorMasksFiltersQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetChallengeEditorMasksFilters($baseChallengeId: ID!) {
      baseChallenge(id: $baseChallengeId) {
        __typename
        appEditorMasks {
          __typename
          id
          name
          cover
          stepsFull {
            __typename
            type
            url
          }
        }
      }
    }
    """

  public let operationName: String = "GetChallengeEditorMasksFilters"

  public var baseChallengeId: GraphQLID

  public init(baseChallengeId: GraphQLID) {
    self.baseChallengeId = baseChallengeId
  }

  public var variables: GraphQLMap? {
    return ["baseChallengeId": baseChallengeId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("baseChallenge", arguments: ["id": GraphQLVariable("baseChallengeId")], type: .nonNull(.object(BaseChallenge.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(baseChallenge: BaseChallenge) {
      self.init(unsafeResultMap: ["__typename": "Query", "baseChallenge": baseChallenge.resultMap])
    }

    public var baseChallenge: BaseChallenge {
      get {
        return BaseChallenge(unsafeResultMap: resultMap["baseChallenge"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "baseChallenge")
      }
    }

    public struct BaseChallenge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["BaseChallenge"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("appEditorMasks", type: .nonNull(.list(.nonNull(.object(AppEditorMask.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(appEditorMasks: [AppEditorMask]) {
        self.init(unsafeResultMap: ["__typename": "BaseChallenge", "appEditorMasks": appEditorMasks.map { (value: AppEditorMask) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var appEditorMasks: [AppEditorMask] {
        get {
          return (resultMap["appEditorMasks"] as! [ResultMap]).map { (value: ResultMap) -> AppEditorMask in AppEditorMask(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: AppEditorMask) -> ResultMap in value.resultMap }, forKey: "appEditorMasks")
        }
      }

      public struct AppEditorMask: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EditorFilter"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("cover", type: .scalar(String.self)),
            GraphQLField("stepsFull", type: .nonNull(.list(.nonNull(.object(StepsFull.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, cover: String? = nil, stepsFull: [StepsFull]) {
          self.init(unsafeResultMap: ["__typename": "EditorFilter", "id": id, "name": name, "cover": cover, "stepsFull": stepsFull.map { (value: StepsFull) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var cover: String? {
          get {
            return resultMap["cover"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "cover")
          }
        }

        public var stepsFull: [StepsFull] {
          get {
            return (resultMap["stepsFull"] as! [ResultMap]).map { (value: ResultMap) -> StepsFull in StepsFull(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: StepsFull) -> ResultMap in value.resultMap }, forKey: "stepsFull")
          }
        }

        public struct StepsFull: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EditorFilterStep"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("type", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(type: String, url: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "EditorFilterStep", "type": type, "url": url])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var type: String {
            get {
              return resultMap["type"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
            }
          }

          public var url: String? {
            get {
              return resultMap["url"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }
        }
      }
    }
  }
}

public final class GetChallengeEditorTemplatesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getChallengeEditorTemplates($baseChallengeId: ID!, $screenHeight: Int!, $screenWidth: Int!) {
      baseChallenge(id: $baseChallengeId) {
        __typename
        appEditorTemplates {
          __typename
          id
          cover
          nameLocalized
          isAttached
          variants {
            __typename
            id
            cover
            clientConfig(
              screenHeight: $screenHeight
              screenWidth: $screenWidth
              is16by9: true
            ) {
              __typename
              items {
                __typename
                filters {
                  __typename
                  id
                  name
                  cover
                  stepsFull {
                    __typename
                    id
                    index
                    type
                    settings
                    url
                    filterId
                    neuralConfig {
                      __typename
                      minPixels
                      maxPixels
                      allowedDimensions {
                        __typename
                        width
                        height
                      }
                      dimensionsMultipleOf
                    }
                  }
                }
                blendMode
                imageUrl
                type
                settings
                textLocalized
                id
                config
                isMovable
                isText
                verticalAlign
                defaultColor
                fontPreset {
                  __typename
                  alignment
                  editorFont {
                    __typename
                    postScriptName
                  }
                  fontSize
                  hasAllCaps
                  hasShadow
                  letterSpacing
                  lineHeight
                }
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "getChallengeEditorTemplates"

  public var baseChallengeId: GraphQLID
  public var screenHeight: Int
  public var screenWidth: Int

  public init(baseChallengeId: GraphQLID, screenHeight: Int, screenWidth: Int) {
    self.baseChallengeId = baseChallengeId
    self.screenHeight = screenHeight
    self.screenWidth = screenWidth
  }

  public var variables: GraphQLMap? {
    return ["baseChallengeId": baseChallengeId, "screenHeight": screenHeight, "screenWidth": screenWidth]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("baseChallenge", arguments: ["id": GraphQLVariable("baseChallengeId")], type: .nonNull(.object(BaseChallenge.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(baseChallenge: BaseChallenge) {
      self.init(unsafeResultMap: ["__typename": "Query", "baseChallenge": baseChallenge.resultMap])
    }

    public var baseChallenge: BaseChallenge {
      get {
        return BaseChallenge(unsafeResultMap: resultMap["baseChallenge"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "baseChallenge")
      }
    }

    public struct BaseChallenge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["BaseChallenge"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("appEditorTemplates", type: .nonNull(.list(.nonNull(.object(AppEditorTemplate.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(appEditorTemplates: [AppEditorTemplate]) {
        self.init(unsafeResultMap: ["__typename": "BaseChallenge", "appEditorTemplates": appEditorTemplates.map { (value: AppEditorTemplate) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var appEditorTemplates: [AppEditorTemplate] {
        get {
          return (resultMap["appEditorTemplates"] as! [ResultMap]).map { (value: ResultMap) -> AppEditorTemplate in AppEditorTemplate(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: AppEditorTemplate) -> ResultMap in value.resultMap }, forKey: "appEditorTemplates")
        }
      }

      public struct AppEditorTemplate: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EditorTemplate"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("cover", type: .scalar(String.self)),
            GraphQLField("nameLocalized", type: .nonNull(.scalar(String.self))),
            GraphQLField("isAttached", type: .nonNull(.scalar(Bool.self))),
            GraphQLField("variants", type: .nonNull(.list(.nonNull(.object(Variant.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, cover: String? = nil, nameLocalized: String, isAttached: Bool, variants: [Variant]) {
          self.init(unsafeResultMap: ["__typename": "EditorTemplate", "id": id, "cover": cover, "nameLocalized": nameLocalized, "isAttached": isAttached, "variants": variants.map { (value: Variant) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var cover: String? {
          get {
            return resultMap["cover"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "cover")
          }
        }

        public var nameLocalized: String {
          get {
            return resultMap["nameLocalized"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "nameLocalized")
          }
        }

        public var isAttached: Bool {
          get {
            return resultMap["isAttached"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "isAttached")
          }
        }

        public var variants: [Variant] {
          get {
            return (resultMap["variants"] as! [ResultMap]).map { (value: ResultMap) -> Variant in Variant(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Variant) -> ResultMap in value.resultMap }, forKey: "variants")
          }
        }

        public struct Variant: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EditorTemplateVariant"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("cover", type: .scalar(String.self)),
              GraphQLField("clientConfig", arguments: ["screenHeight": GraphQLVariable("screenHeight"), "screenWidth": GraphQLVariable("screenWidth"), "is16by9": true], type: .nonNull(.object(ClientConfig.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, cover: String? = nil, clientConfig: ClientConfig) {
            self.init(unsafeResultMap: ["__typename": "EditorTemplateVariant", "id": id, "cover": cover, "clientConfig": clientConfig.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var cover: String? {
            get {
              return resultMap["cover"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "cover")
            }
          }

          public var clientConfig: ClientConfig {
            get {
              return ClientConfig(unsafeResultMap: resultMap["clientConfig"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "clientConfig")
            }
          }

          public struct ClientConfig: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["EditorTemplateVariantConfig"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(items: [Item]) {
              self.init(unsafeResultMap: ["__typename": "EditorTemplateVariantConfig", "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var items: [Item] {
              get {
                return (resultMap["items"] as! [ResultMap]).map { (value: ResultMap) -> Item in Item(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Item) -> ResultMap in value.resultMap }, forKey: "items")
              }
            }

            public struct Item: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ClientEditorTemplateItem"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("filters", type: .nonNull(.list(.nonNull(.object(Filter.selections))))),
                  GraphQLField("blendMode", type: .nonNull(.scalar(String.self))),
                  GraphQLField("imageUrl", type: .scalar(String.self)),
                  GraphQLField("type", type: .nonNull(.scalar(Int.self))),
                  GraphQLField("settings", type: .nonNull(.scalar(JSON.self))),
                  GraphQLField("textLocalized", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                  GraphQLField("config", type: .nonNull(.scalar(JSON.self))),
                  GraphQLField("isMovable", type: .nonNull(.scalar(Bool.self))),
                  GraphQLField("isText", type: .nonNull(.scalar(Bool.self))),
                  GraphQLField("verticalAlign", type: .scalar(Int.self)),
                  GraphQLField("defaultColor", type: .scalar(String.self)),
                  GraphQLField("fontPreset", type: .object(FontPreset.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(filters: [Filter], blendMode: String, imageUrl: String? = nil, type: Int, settings: JSON, textLocalized: String, id: GraphQLID, config: JSON, isMovable: Bool, isText: Bool, verticalAlign: Int? = nil, defaultColor: String? = nil, fontPreset: FontPreset? = nil) {
                self.init(unsafeResultMap: ["__typename": "ClientEditorTemplateItem", "filters": filters.map { (value: Filter) -> ResultMap in value.resultMap }, "blendMode": blendMode, "imageUrl": imageUrl, "type": type, "settings": settings, "textLocalized": textLocalized, "id": id, "config": config, "isMovable": isMovable, "isText": isText, "verticalAlign": verticalAlign, "defaultColor": defaultColor, "fontPreset": fontPreset.flatMap { (value: FontPreset) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var filters: [Filter] {
                get {
                  return (resultMap["filters"] as! [ResultMap]).map { (value: ResultMap) -> Filter in Filter(unsafeResultMap: value) }
                }
                set {
                  resultMap.updateValue(newValue.map { (value: Filter) -> ResultMap in value.resultMap }, forKey: "filters")
                }
              }

              public var blendMode: String {
                get {
                  return resultMap["blendMode"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "blendMode")
                }
              }

              public var imageUrl: String? {
                get {
                  return resultMap["imageUrl"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "imageUrl")
                }
              }

              public var type: Int {
                get {
                  return resultMap["type"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "type")
                }
              }

              public var settings: JSON {
                get {
                  return resultMap["settings"]! as! JSON
                }
                set {
                  resultMap.updateValue(newValue, forKey: "settings")
                }
              }

              public var textLocalized: String {
                get {
                  return resultMap["textLocalized"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "textLocalized")
                }
              }

              public var id: GraphQLID {
                get {
                  return resultMap["id"]! as! GraphQLID
                }
                set {
                  resultMap.updateValue(newValue, forKey: "id")
                }
              }

              public var config: JSON {
                get {
                  return resultMap["config"]! as! JSON
                }
                set {
                  resultMap.updateValue(newValue, forKey: "config")
                }
              }

              public var isMovable: Bool {
                get {
                  return resultMap["isMovable"]! as! Bool
                }
                set {
                  resultMap.updateValue(newValue, forKey: "isMovable")
                }
              }

              public var isText: Bool {
                get {
                  return resultMap["isText"]! as! Bool
                }
                set {
                  resultMap.updateValue(newValue, forKey: "isText")
                }
              }

              public var verticalAlign: Int? {
                get {
                  return resultMap["verticalAlign"] as? Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "verticalAlign")
                }
              }

              public var defaultColor: String? {
                get {
                  return resultMap["defaultColor"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "defaultColor")
                }
              }

              public var fontPreset: FontPreset? {
                get {
                  return (resultMap["fontPreset"] as? ResultMap).flatMap { FontPreset(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "fontPreset")
                }
              }

              public struct Filter: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["EditorFilter"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                    GraphQLField("cover", type: .scalar(String.self)),
                    GraphQLField("stepsFull", type: .nonNull(.list(.nonNull(.object(StepsFull.selections))))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: GraphQLID, name: String, cover: String? = nil, stepsFull: [StepsFull]) {
                  self.init(unsafeResultMap: ["__typename": "EditorFilter", "id": id, "name": name, "cover": cover, "stepsFull": stepsFull.map { (value: StepsFull) -> ResultMap in value.resultMap }])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var id: GraphQLID {
                  get {
                    return resultMap["id"]! as! GraphQLID
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "id")
                  }
                }

                public var name: String {
                  get {
                    return resultMap["name"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "name")
                  }
                }

                public var cover: String? {
                  get {
                    return resultMap["cover"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "cover")
                  }
                }

                public var stepsFull: [StepsFull] {
                  get {
                    return (resultMap["stepsFull"] as! [ResultMap]).map { (value: ResultMap) -> StepsFull in StepsFull(unsafeResultMap: value) }
                  }
                  set {
                    resultMap.updateValue(newValue.map { (value: StepsFull) -> ResultMap in value.resultMap }, forKey: "stepsFull")
                  }
                }

                public struct StepsFull: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["EditorFilterStep"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                      GraphQLField("index", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("type", type: .nonNull(.scalar(String.self))),
                      GraphQLField("settings", type: .nonNull(.scalar(JSON.self))),
                      GraphQLField("url", type: .scalar(String.self)),
                      GraphQLField("filterId", type: .nonNull(.scalar(GraphQLID.self))),
                      GraphQLField("neuralConfig", type: .object(NeuralConfig.selections)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: GraphQLID, index: Int, type: String, settings: JSON, url: String? = nil, filterId: GraphQLID, neuralConfig: NeuralConfig? = nil) {
                    self.init(unsafeResultMap: ["__typename": "EditorFilterStep", "id": id, "index": index, "type": type, "settings": settings, "url": url, "filterId": filterId, "neuralConfig": neuralConfig.flatMap { (value: NeuralConfig) -> ResultMap in value.resultMap }])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var id: GraphQLID {
                    get {
                      return resultMap["id"]! as! GraphQLID
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "id")
                    }
                  }

                  public var index: Int {
                    get {
                      return resultMap["index"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "index")
                    }
                  }

                  public var type: String {
                    get {
                      return resultMap["type"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "type")
                    }
                  }

                  public var settings: JSON {
                    get {
                      return resultMap["settings"]! as! JSON
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "settings")
                    }
                  }

                  public var url: String? {
                    get {
                      return resultMap["url"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "url")
                    }
                  }

                  public var filterId: GraphQLID {
                    get {
                      return resultMap["filterId"]! as! GraphQLID
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "filterId")
                    }
                  }

                  public var neuralConfig: NeuralConfig? {
                    get {
                      return (resultMap["neuralConfig"] as? ResultMap).flatMap { NeuralConfig(unsafeResultMap: $0) }
                    }
                    set {
                      resultMap.updateValue(newValue?.resultMap, forKey: "neuralConfig")
                    }
                  }

                  public struct NeuralConfig: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["AppNeuralFilterConfig"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("minPixels", type: .nonNull(.scalar(Int.self))),
                        GraphQLField("maxPixels", type: .nonNull(.scalar(Int.self))),
                        GraphQLField("allowedDimensions", type: .list(.nonNull(.object(AllowedDimension.selections)))),
                        GraphQLField("dimensionsMultipleOf", type: .nonNull(.scalar(Int.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(minPixels: Int, maxPixels: Int, allowedDimensions: [AllowedDimension]? = nil, dimensionsMultipleOf: Int) {
                      self.init(unsafeResultMap: ["__typename": "AppNeuralFilterConfig", "minPixels": minPixels, "maxPixels": maxPixels, "allowedDimensions": allowedDimensions.flatMap { (value: [AllowedDimension]) -> [ResultMap] in value.map { (value: AllowedDimension) -> ResultMap in value.resultMap } }, "dimensionsMultipleOf": dimensionsMultipleOf])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var minPixels: Int {
                      get {
                        return resultMap["minPixels"]! as! Int
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "minPixels")
                      }
                    }

                    public var maxPixels: Int {
                      get {
                        return resultMap["maxPixels"]! as! Int
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "maxPixels")
                      }
                    }

                    public var allowedDimensions: [AllowedDimension]? {
                      get {
                        return (resultMap["allowedDimensions"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [AllowedDimension] in value.map { (value: ResultMap) -> AllowedDimension in AllowedDimension(unsafeResultMap: value) } }
                      }
                      set {
                        resultMap.updateValue(newValue.flatMap { (value: [AllowedDimension]) -> [ResultMap] in value.map { (value: AllowedDimension) -> ResultMap in value.resultMap } }, forKey: "allowedDimensions")
                      }
                    }

                    public var dimensionsMultipleOf: Int {
                      get {
                        return resultMap["dimensionsMultipleOf"]! as! Int
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "dimensionsMultipleOf")
                      }
                    }

                    public struct AllowedDimension: GraphQLSelectionSet {
                      public static let possibleTypes: [String] = ["Dimension"]

                      public static var selections: [GraphQLSelection] {
                        return [
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("width", type: .nonNull(.scalar(Int.self))),
                          GraphQLField("height", type: .nonNull(.scalar(Int.self))),
                        ]
                      }

                      public private(set) var resultMap: ResultMap

                      public init(unsafeResultMap: ResultMap) {
                        self.resultMap = unsafeResultMap
                      }

                      public init(width: Int, height: Int) {
                        self.init(unsafeResultMap: ["__typename": "Dimension", "width": width, "height": height])
                      }

                      public var __typename: String {
                        get {
                          return resultMap["__typename"]! as! String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "__typename")
                        }
                      }

                      public var width: Int {
                        get {
                          return resultMap["width"]! as! Int
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "width")
                        }
                      }

                      public var height: Int {
                        get {
                          return resultMap["height"]! as! Int
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "height")
                        }
                      }
                    }
                  }
                }
              }

              public struct FontPreset: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["EditorFontPreset"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("alignment", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("editorFont", type: .nonNull(.object(EditorFont.selections))),
                    GraphQLField("fontSize", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("hasAllCaps", type: .nonNull(.scalar(Bool.self))),
                    GraphQLField("hasShadow", type: .nonNull(.scalar(Bool.self))),
                    GraphQLField("letterSpacing", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("lineHeight", type: .nonNull(.scalar(Double.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(alignment: Int, editorFont: EditorFont, fontSize: Double, hasAllCaps: Bool, hasShadow: Bool, letterSpacing: Double, lineHeight: Double) {
                  self.init(unsafeResultMap: ["__typename": "EditorFontPreset", "alignment": alignment, "editorFont": editorFont.resultMap, "fontSize": fontSize, "hasAllCaps": hasAllCaps, "hasShadow": hasShadow, "letterSpacing": letterSpacing, "lineHeight": lineHeight])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var alignment: Int {
                  get {
                    return resultMap["alignment"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "alignment")
                  }
                }

                public var editorFont: EditorFont {
                  get {
                    return EditorFont(unsafeResultMap: resultMap["editorFont"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "editorFont")
                  }
                }

                public var fontSize: Double {
                  get {
                    return resultMap["fontSize"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "fontSize")
                  }
                }

                public var hasAllCaps: Bool {
                  get {
                    return resultMap["hasAllCaps"]! as! Bool
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "hasAllCaps")
                  }
                }

                public var hasShadow: Bool {
                  get {
                    return resultMap["hasShadow"]! as! Bool
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "hasShadow")
                  }
                }

                public var letterSpacing: Double {
                  get {
                    return resultMap["letterSpacing"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "letterSpacing")
                  }
                }

                public var lineHeight: Double {
                  get {
                    return resultMap["lineHeight"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "lineHeight")
                  }
                }

                public struct EditorFont: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["EditorFont"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("postScriptName", type: .nonNull(.scalar(String.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(postScriptName: String) {
                    self.init(unsafeResultMap: ["__typename": "EditorFont", "postScriptName": postScriptName])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var postScriptName: String {
                    get {
                      return resultMap["postScriptName"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "postScriptName")
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class GetChallengeEditorTexturesFiltersQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetChallengeEditorTexturesFilters($baseChallengeId: ID!) {
      baseChallenge(id: $baseChallengeId) {
        __typename
        appEditorTextures {
          __typename
          stepsFull {
            __typename
            type
            url
            settings
          }
          name
          cover
          id
        }
      }
    }
    """

  public let operationName: String = "GetChallengeEditorTexturesFilters"

  public var baseChallengeId: GraphQLID

  public init(baseChallengeId: GraphQLID) {
    self.baseChallengeId = baseChallengeId
  }

  public var variables: GraphQLMap? {
    return ["baseChallengeId": baseChallengeId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("baseChallenge", arguments: ["id": GraphQLVariable("baseChallengeId")], type: .nonNull(.object(BaseChallenge.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(baseChallenge: BaseChallenge) {
      self.init(unsafeResultMap: ["__typename": "Query", "baseChallenge": baseChallenge.resultMap])
    }

    public var baseChallenge: BaseChallenge {
      get {
        return BaseChallenge(unsafeResultMap: resultMap["baseChallenge"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "baseChallenge")
      }
    }

    public struct BaseChallenge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["BaseChallenge"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("appEditorTextures", type: .nonNull(.list(.nonNull(.object(AppEditorTexture.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(appEditorTextures: [AppEditorTexture]) {
        self.init(unsafeResultMap: ["__typename": "BaseChallenge", "appEditorTextures": appEditorTextures.map { (value: AppEditorTexture) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var appEditorTextures: [AppEditorTexture] {
        get {
          return (resultMap["appEditorTextures"] as! [ResultMap]).map { (value: ResultMap) -> AppEditorTexture in AppEditorTexture(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: AppEditorTexture) -> ResultMap in value.resultMap }, forKey: "appEditorTextures")
        }
      }

      public struct AppEditorTexture: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EditorFilter"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("stepsFull", type: .nonNull(.list(.nonNull(.object(StepsFull.selections))))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("cover", type: .scalar(String.self)),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(stepsFull: [StepsFull], name: String, cover: String? = nil, id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "EditorFilter", "stepsFull": stepsFull.map { (value: StepsFull) -> ResultMap in value.resultMap }, "name": name, "cover": cover, "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var stepsFull: [StepsFull] {
          get {
            return (resultMap["stepsFull"] as! [ResultMap]).map { (value: ResultMap) -> StepsFull in StepsFull(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: StepsFull) -> ResultMap in value.resultMap }, forKey: "stepsFull")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var cover: String? {
          get {
            return resultMap["cover"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "cover")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public struct StepsFull: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EditorFilterStep"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("type", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .scalar(String.self)),
              GraphQLField("settings", type: .nonNull(.scalar(JSON.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(type: String, url: String? = nil, settings: JSON) {
            self.init(unsafeResultMap: ["__typename": "EditorFilterStep", "type": type, "url": url, "settings": settings])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var type: String {
            get {
              return resultMap["type"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
            }
          }

          public var url: String? {
            get {
              return resultMap["url"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }

          public var settings: JSON {
            get {
              return resultMap["settings"]! as! JSON
            }
            set {
              resultMap.updateValue(newValue, forKey: "settings")
            }
          }
        }
      }
    }
  }
}

public final class GetChallengeMetaQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetChallengeMeta($baseChallengeId: ID!) {
      baseChallenge(id: $baseChallengeId) {
        __typename
        titleLocalized
        subtitleLocalized
        hasAttachedStickerPacks
        appAttachedEditorTemplate {
          __typename
          isAttached
        }
      }
    }
    """

  public let operationName: String = "GetChallengeMeta"

  public var baseChallengeId: GraphQLID

  public init(baseChallengeId: GraphQLID) {
    self.baseChallengeId = baseChallengeId
  }

  public var variables: GraphQLMap? {
    return ["baseChallengeId": baseChallengeId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("baseChallenge", arguments: ["id": GraphQLVariable("baseChallengeId")], type: .nonNull(.object(BaseChallenge.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(baseChallenge: BaseChallenge) {
      self.init(unsafeResultMap: ["__typename": "Query", "baseChallenge": baseChallenge.resultMap])
    }

    public var baseChallenge: BaseChallenge {
      get {
        return BaseChallenge(unsafeResultMap: resultMap["baseChallenge"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "baseChallenge")
      }
    }

    public struct BaseChallenge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["BaseChallenge"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("titleLocalized", type: .nonNull(.scalar(String.self))),
          GraphQLField("subtitleLocalized", type: .nonNull(.scalar(String.self))),
          GraphQLField("hasAttachedStickerPacks", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("appAttachedEditorTemplate", type: .object(AppAttachedEditorTemplate.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(titleLocalized: String, subtitleLocalized: String, hasAttachedStickerPacks: Bool, appAttachedEditorTemplate: AppAttachedEditorTemplate? = nil) {
        self.init(unsafeResultMap: ["__typename": "BaseChallenge", "titleLocalized": titleLocalized, "subtitleLocalized": subtitleLocalized, "hasAttachedStickerPacks": hasAttachedStickerPacks, "appAttachedEditorTemplate": appAttachedEditorTemplate.flatMap { (value: AppAttachedEditorTemplate) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var titleLocalized: String {
        get {
          return resultMap["titleLocalized"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "titleLocalized")
        }
      }

      public var subtitleLocalized: String {
        get {
          return resultMap["subtitleLocalized"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "subtitleLocalized")
        }
      }

      public var hasAttachedStickerPacks: Bool {
        get {
          return resultMap["hasAttachedStickerPacks"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "hasAttachedStickerPacks")
        }
      }

      public var appAttachedEditorTemplate: AppAttachedEditorTemplate? {
        get {
          return (resultMap["appAttachedEditorTemplate"] as? ResultMap).flatMap { AppAttachedEditorTemplate(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "appAttachedEditorTemplate")
        }
      }

      public struct AppAttachedEditorTemplate: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EditorTemplate"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("isAttached", type: .nonNull(.scalar(Bool.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(isAttached: Bool) {
          self.init(unsafeResultMap: ["__typename": "EditorTemplate", "isAttached": isAttached])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var isAttached: Bool {
          get {
            return resultMap["isAttached"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "isAttached")
          }
        }
      }
    }
  }
}

public final class GetChallengeStickerPacksFullQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetChallengeStickerPacksFull($baseChallengeId: ID!) {
      baseChallenge(id: $baseChallengeId) {
        __typename
        appStickerPacks {
          __typename
          titleLocalized
          stickersFull {
            __typename
            uri
          }
        }
      }
    }
    """

  public let operationName: String = "GetChallengeStickerPacksFull"

  public var baseChallengeId: GraphQLID

  public init(baseChallengeId: GraphQLID) {
    self.baseChallengeId = baseChallengeId
  }

  public var variables: GraphQLMap? {
    return ["baseChallengeId": baseChallengeId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("baseChallenge", arguments: ["id": GraphQLVariable("baseChallengeId")], type: .nonNull(.object(BaseChallenge.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(baseChallenge: BaseChallenge) {
      self.init(unsafeResultMap: ["__typename": "Query", "baseChallenge": baseChallenge.resultMap])
    }

    public var baseChallenge: BaseChallenge {
      get {
        return BaseChallenge(unsafeResultMap: resultMap["baseChallenge"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "baseChallenge")
      }
    }

    public struct BaseChallenge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["BaseChallenge"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("appStickerPacks", type: .nonNull(.list(.nonNull(.object(AppStickerPack.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(appStickerPacks: [AppStickerPack]) {
        self.init(unsafeResultMap: ["__typename": "BaseChallenge", "appStickerPacks": appStickerPacks.map { (value: AppStickerPack) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var appStickerPacks: [AppStickerPack] {
        get {
          return (resultMap["appStickerPacks"] as! [ResultMap]).map { (value: ResultMap) -> AppStickerPack in AppStickerPack(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: AppStickerPack) -> ResultMap in value.resultMap }, forKey: "appStickerPacks")
        }
      }

      public struct AppStickerPack: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["StickerPack"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("titleLocalized", type: .nonNull(.scalar(String.self))),
            GraphQLField("stickersFull", type: .nonNull(.list(.nonNull(.object(StickersFull.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(titleLocalized: String, stickersFull: [StickersFull]) {
          self.init(unsafeResultMap: ["__typename": "StickerPack", "titleLocalized": titleLocalized, "stickersFull": stickersFull.map { (value: StickersFull) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var titleLocalized: String {
          get {
            return resultMap["titleLocalized"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "titleLocalized")
          }
        }

        public var stickersFull: [StickersFull] {
          get {
            return (resultMap["stickersFull"] as! [ResultMap]).map { (value: ResultMap) -> StickersFull in StickersFull(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: StickersFull) -> ResultMap in value.resultMap }, forKey: "stickersFull")
          }
        }

        public struct StickersFull: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Sticker"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("uri", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(uri: String) {
            self.init(unsafeResultMap: ["__typename": "Sticker", "uri": uri])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var uri: String {
            get {
              return resultMap["uri"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "uri")
            }
          }
        }
      }
    }
  }
}
