# Privacy answers for the build with anonymous statistics

Answers for App Store Connect (App Privacy) and Google Play Console (Data
safety) from the first Puff build that sends anonymous gameplay statistics
(`docs/telemetry.md`, `ol1n_telemetry`). They match
`ios/Runner/PrivacyInfo.xcprivacy` and `docs/privacy.html`.

Order: **policy → forms → key → release.** Fill them in only after the new
`docs/privacy.html` is live on GitHub Pages, and before a build with the
`TELEMETRY_KEY` secret is submitted. A build without the key sends nothing,
so the old answers stay true for it. Check the current wording of both forms
before ticking; compare with what is declared today and keep anything else
already declared there.

What is sent, in one line: screens and seconds on them, run start and end
(mode, environment, modifier, palette, result, seconds, heat tier, score,
best combo), first use of features in a session, launch-to-menu time in
milliseconds, app version, platform, language, session and day bands. No
identifier, no text, no device model. Received and stored by the developer on
its own server in the EU (Czech Republic); nobody else receives it. The IP
address is not stored; only the country is kept. Kept 12 months. Switch:
ANONYMOUS STATS in Settings (deletes unsent records at once).

## App Store Connect → App Privacy

**Privacy Policy URL:** `https://lioilsources.github.io/puff/privacy.html`,
unchanged.

**Do you or your third-party partners collect data from this app?** **Yes.**

| Category → type | Linked to the user? | Used for tracking? | Purpose |
|---|---|---|---|
| Usage Data → **Product Interaction** | **No** | **No** | **Analytics** |
| Diagnostics → **Performance Data** | **No** | **No** | **Analytics** |
| Location → **Coarse Location** | **No** | **No** | **Analytics** |

- *Product Interaction*: launches, screens, run starts and ends, features
  used.
- *Performance Data*: launch-to-menu time in milliseconds (`menu_ready`).
- *Coarse Location*: the receiver keeps the country from the connection
  (Cloudflare country header), never the IP address. If the owner turns the
  country off for Puff at the receiver, untick this row and remove
  `NSPrivacyCollectedDataTypeCoarseLocation` from the privacy manifest.

Not collected (leave unticked): Contact Info, Health & Fitness, Financial
Info, Precise Location, Sensitive Info, Contacts, User Content, Browsing
History, Search History, Identifiers (no User ID and no Device ID: the
session id is random, lives in memory and is never reused), Purchases, Other
Usage Data, Crash Data, Other Diagnostic Data, Other Data.

**Linked to the user: No** for every type: no account, no identifier; two
sessions cannot be connected to each other.

**Tracking: No.** Nothing is combined with other companies' data, nothing is
shared with data brokers, there is no advertising. No App Tracking
Transparency prompt (`NSPrivacyTracking` is `false`).

Game Center scores and achievements are Apple's data under the player's Game
Center account, not collected by the app; not declared here (as before).

## Google Play Console → App content → Data safety

- Does your app collect or share any of the required user data types?
  **Yes.**
- Is all of the user data collected by your app encrypted in transit?
  **Yes** (the statistics client refuses a non-`https` receiver).
- Do you provide a way for users to request that their data is deleted?
  **No.** There is no account. The statistics carry no identifier, so no
  record can be found for a person; switching them off deletes the unsent
  ones on the device, and the server deletes them after 12 months. (Deletion
  requests are required only for apps with account creation.)

Data types, all **Collected**, **not shared** (the developer's own server, no
third party), **not processed ephemerally**, **optional** (ANONYMOUS STATS in
Settings):

| Data type | Purpose |
|---|---|
| App activity → **App interactions** | **Analytics** |
| App info and performance → **Diagnostics** (launch-to-menu time) | **Analytics** |
| Location → **Approximate location** (country only) | **Analytics** |

If the country is turned off at the receiver, drop the *Approximate location*
row.

Not collected: precise location, personal info, financial info, health,
messages, photos and videos, audio, files, calendar, contacts, web browsing,
device or other IDs, crash logs. `games_services` is linked but idle on
Android (no Play Games IDs), so it adds nothing.

**Advertising ID: No** (unchanged).

## Outside this repository

- App Store Connect → App Privacy: the table above.
- Google Play Console → Data safety: the table above.
- The Puff page on olin.now: wherever it says Puff sends nothing or has no
  analytics, say instead that it sends anonymous statistics that can be
  switched off (no ads, no account and no third-party analytics stay true).
- The App Store description and Play listing texts in `APP_STORE.md` and
  `GOOGLE_PLAY.md` (NO STRINGS / BEZ HÁČKŮ) go live with the next metadata
  update; other Play languages, if added in the console, need the same
  change.
