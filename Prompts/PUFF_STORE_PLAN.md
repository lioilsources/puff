# PUFF_STORE_PLAN.md — změny v kódu pro build 1.3.0

Cíl: připravit Puff (Flutter, bundle com.ol1n.puff, App Store ID 6808586613)
na A/B test ikony a na herní nástroje App Store (Game Center Challenges,
In-App Events, hodnocení). Store-side kroky (název, klíčová slova, kategorie,
promo text, screenshoty, události) řeší Ol1n v App Store Connect; tento soubor
je jen o kódu.

Kontext (7. 11. 2026): živá iOS 1.2.3, 19 lokalizací, bez nákupů. Za 30 dní
6 132 zobrazení, proklik na stránku 0,9 %. Ikona je logo Ananas&Bananas a
název slibuje „squishy“ hru. Game Center: 4 žebříčky, 0 achievementů.

## Úkoly a stav (1.3.0)

| # | Úkol | Stav |
|---|---|---|
| 1 | Alternativní ikony v buildu (PPO), v appce nepřepínat | Hotovo už v 1.2.2: `AppIcon-Blast/-Cloud/-Shatter`, `INCLUDE_ALL_APPICON_ASSETS = YES`. Nová grafika z výběru ikon je jiný build. |
| 2 | Game Center: 10–15 achievementů + Challenges (iOS 26, za `#available`) | 14 achievementů (`sim/achievements.dart`), tlačítka ACHIEVEMENTS / CHALLENGES, `ios/Runner/PuffGameKit.swift`. Seznam pro ASC v `store/APP_STORE.md` → *1.3.0*. |
| 3 | Týdenní challenge: stejný seed, recurring leaderboard, zapínání datem | `sim/weekly.dart`, od 23. 11. 2026, žebříček `puff.weekly`. |
| 4 | Sezonní paleta podle data nebo vzdálené konfigurace | Holiday 1. 12. – 6. 1. každý rok (`sim/season.dart`), JSON `olin.now/apps/puff/config.json`. |
| 5 | Deep linky `puff://event/<id>`, `puff://palette/<id>`, `puff://play`; jinak menu | `app/deep_link.dart` + app_links, schéma v Info.plist a manifestu. |
| 6 | Výzva k hodnocení po rekordu nebo combu x4, 1× za verzi, ne v 1. sezení | `app/review_policy.dart` + in_app_review. |
| 7 | Slabší záblesky + systémové Reduce Motion | Nastavení REDUCED FLASHES, `Tuning.calmIntensity`. Seznam pro štítky v `store/APP_STORE.md`. |
| 8 | Sdílení skóre po rekordu: karta + odkaz s `ct=share&pt=` | `app/share_card.dart`, token `ShareLinks.providerToken` doplní Ol1n. |

Výstup: build 1.3.0 v TestFlightu, seznam úkolů pro ASC. Nic neodesílat ke
schválení bez pokynu Ol1na.

## Google Play (stejné období, mimo kód)

Proklik 1,6 %, konverze návštěva → instalace 6,5 %. Úkoly podle dopadu:
snímky s titulky („Hold. Drag. Release.“ …), video na šířku z reálné hry
(ověřit, zda Short je skutečný gameplay; jinak ho stáhnout), název a krátký
popis s „relaxing / satisfying / physics / offline“, zkrácený dlouhý popis,
konkrétní What's new, štítky obchodu, In-App Review (pokrývá bod 6 výše),
experimenty se záznamem, vlastní záznamy, propagační obsah. Každá změna
záznamu jde ke kontrole Google: posílat dávkově a předem se zeptat Ol1na.
AI deklarace podkladů: pokud video/grafika vznikly v AI, změnit — zeptat se.
