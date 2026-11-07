import Foundation
import GameKit

/// The Game Center features games_services does not cover: challenges and
/// game activities, both iOS 26+. The app still runs on iOS 15, so every
/// call checks availability and reports "unsupported" below 26.
///
/// Challenges are defined in App Store Connect on top of the leaderboards;
/// the scores games_services already submits are what they count. The app
/// only has to offer a way into the challenge UI.
///
/// Game activities are how the Games app, an In-App Event or a challenge
/// invite opens the game for a particular setup: the activity's properties
/// (`environment`, `modifier`, `mode`) are handed to Dart, which starts that
/// run, and the run's score is reported back on the activity when it ends.
final class PuffGameKit: NSObject {
  static let shared = PuffGameKit()

  /// Set by the channel; receives activities as they arrive.
  var onActivity: (([String: Any]) -> Void)?

  /// An activity that arrived before Dart was listening (cold launch from
  /// the Games app). Dart collects it once at startup.
  private(set) var pendingActivity: [String: Any]?

  /// The iOS 26 listener, once registered; typed loosely so the class itself
  /// stays usable on older systems.
  private var listener: AnyObject?
  private var current: AnyObject?

  override init() {
    super.init()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(authenticationChanged),
      name: .GKPlayerAuthenticationDidChangeNotificationName,
      object: nil)
    authenticationChanged()
  }

  /// Listeners only work once the local player is signed in, and the sign-in
  /// is games_services' business; follow it instead of driving it.
  @objc private func authenticationChanged() {
    guard #available(iOS 26.0, *), GKLocalPlayer.local.isAuthenticated, listener == nil
    else { return }
    let l = ActivityListener(owner: self)
    GKLocalPlayer.local.register(l)
    listener = l
  }

  func takePendingActivity() -> [String: Any]? {
    defer { pendingActivity = nil }
    return pendingActivity
  }

  func hasChallenges(_ done: @escaping (Bool) -> Void) {
    guard #available(iOS 26.0, *), GKLocalPlayer.local.isAuthenticated else {
      done(false)
      return
    }
    GKChallengeDefinition.loadChallengeDefinitions { definitions, _ in
      DispatchQueue.main.async { done(!(definitions ?? []).isEmpty) }
    }
  }

  func showChallenges(_ done: @escaping (Bool) -> Void) {
    guard #available(iOS 26.0, *), GKLocalPlayer.local.isAuthenticated else {
      done(false)
      return
    }
    GKAccessPoint.shared.triggerForChallenges {}
    done(true)
  }

  /// Reports [score] on the running activity and ends it. Without an
  /// activity this does nothing.
  func finishActivity(score: Int, leaderboardID: String, _ done: @escaping () -> Void) {
    guard #available(iOS 26.0, *), let activity = current as? GKGameActivity else {
      done()
      return
    }
    current = nil
    GKLeaderboard.loadLeaderboards(IDs: [leaderboardID]) { boards, _ in
      DispatchQueue.main.async {
        if let board = boards?.first {
          activity.setScore(on: board, to: score)
        }
        activity.end()
        done()
      }
    }
  }

  @available(iOS 26.0, *)
  fileprivate func received(_ activity: GKGameActivity, _ completionHandler: @escaping (Bool) -> Void) {
    DispatchQueue.main.async {
      if let previous = self.current as? GKGameActivity, previous.state == .active {
        previous.end()
      }
      self.current = activity
      activity.start()
      let payload: [String: Any] = [
        "definition": activity.activityDefinition.identifier,
        "properties": activity.properties,
      ]
      if let onActivity = self.onActivity {
        onActivity(payload)
      } else {
        self.pendingActivity = payload
      }
      completionHandler(true)
    }
  }
}

@available(iOS 26.0, *)
private final class ActivityListener: NSObject, GKLocalPlayerListener {
  init(owner: PuffGameKit) {
    self.owner = owner
  }

  private weak var owner: PuffGameKit?

  func player(
    _ player: GKPlayer, wantsToPlay activity: GKGameActivity,
    completionHandler: @escaping (Bool) -> Void
  ) {
    guard let owner else {
      completionHandler(false)
      return
    }
    owner.received(activity, completionHandler)
  }
}
