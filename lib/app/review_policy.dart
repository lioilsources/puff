/// When to ask for a rating.
///
/// Only right after a run that went well (a new personal best, or a combo
/// that reached x4), at most once per app version, and never in the first
/// session: a player who has not come back yet has nothing to rate. The
/// system decides on its own whether the sheet actually appears, so asking is
/// cheap, but asking at the wrong moment is not.
class ReviewPolicy {
  const ReviewPolicy();

  bool shouldAsk({
    required String appVersion,
    required String? lastAskedVersion,
    required int session,
    required bool newBest,
    required bool comboX4,
  }) {
    if (session <= 1) {
      return false;
    }
    if (lastAskedVersion == appVersion) {
      return false;
    }
    return newBest || comboX4;
  }
}
