import Flutter
import Foundation

/// `puff/gamekit`: the Dart side of [PuffGameKit]. Calls answer `false` or
/// `nil` wherever the feature is missing, so Dart needs no version checks.
enum PuffGameKitChannel {
  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "puff/gamekit", binaryMessenger: messenger)
    let kit = PuffGameKit.shared
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "listen":
        // Dart is ready: push from now on, and hand over what came earlier.
        kit.onActivity = { payload in
          channel.invokeMethod("activity", arguments: payload)
        }
        result(kit.takePendingActivity())
      case "hasChallenges":
        kit.hasChallenges { result($0) }
      case "showChallenges":
        kit.showChallenges { result($0) }
      case "finishActivity":
        let args = call.arguments as? [String: Any] ?? [:]
        let score = args["score"] as? Int ?? 0
        let board = args["leaderboard"] as? String ?? ""
        kit.finishActivity(score: score, leaderboardID: board) { result(nil) }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
