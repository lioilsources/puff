# PUFF — Monetizace

Strategie, jak z Puffu udělat něco, co vydělává, aniž by přestal být tím, co je:
neonovou fyzikální hračkou na jeden prst, bez čekání a bez menu mezi hráčem
a dalším výbuchem.

Předloha: ekonomika Candy Crush Saga (životy → hard currency → boostery →
nákup). Ne všechno z ní se do Puffu hodí, a tenhle dokument říká, co ano,
co ne a proč.

---

## 0. Kde Puff dnes stojí

Fakta, ze kterých se vychází (stav repa 1.0.3, září 2026):

- **Endless arkáda bez levelů.** Jeden run, jedno skóre, konec když jádro
  dostane 5 zásahů (`Tuning.coreHp`). Žádná progrese mezi runy kromě
  lokálního nejlepšího skóre a Game Center žebříčků (jeden na prostředí).
- **Sólo vývoj, žádný backend, žádná analytika.** Nic neopouští zařízení.
  To omezuje, co jde dělat (personalizované nabídky, server-side ekonomika,
  A/B testy), ale zároveň drží náklady na nule.
- **Store listing prodává „NO STRINGS“.** Popis v `store/APP_STORE.md`
  výslovně slibuje: žádné reklamy, žádné IAP, žádné předplatné, žádný
  tracking, žádný síťový kód. To je reálný diferenciátor v kategorii plné
  Voodoo klonů a zároveň závazek, který monetizace nutně otevře.
- **Co už ve hře je a dá se prodat nebo zabalit:** 6 palet, 4 prostředí,
  5 modifikátorů, 3 kvality renderu, seedovaný RNG (`PuffGame(seed:)`),
  editor palet je ve specifikaci (`PUFF_PLAN.md` §7) ale nikdy nevznikl.
- **Nová závislost = nová rizika.** Projekt drží iOS pluginy přes Swift
  Package Manager (žádný Podfile). Každý plugin musí SPM umět, jinak se
  rozbije CI (viz DEVLOG, `pod install`).

## 1. Co z Candy Crush do Puffu přenést a co ne

| Mechanika Candy Crush | Verdikt pro Puff | Proč |
|---|---|---|
| Omezené životy, čekání na doplnění | **Ne** | Listing slibuje „nothing is on a timer except you“. Energy timer zabije to jediné, čím se Puff liší od konkurence, a hra bez levelů nemá kam „životy“ pověsit. |
| Pokračování po prohře za peníze | **Ano**, upraveně | Přesně sedí: hráč má za sebou 4 minuty runu, k rekordu chybí pár set bodů, jádro právě prasklo. „Opravit jádro a hrát dál“ je nejsilnější platební moment, který Puff přirozeně má. |
| Boostery, které usnadní level | **Ano, ale jen mimo žebříček** | Game Center žebříčky právě přibyly. Placené výhody v hodnoceném skóre je zabijí. Boostery patří do denní výzvy a do „sandbox“ runů, ne do ranked. |
| Čekej, nebo zaplať | **Ano, jako denní výzva** | Místo timeru na hraní: jedna denní výzva se společným seedem, jeden pokus zdarma. Čekáš na zítřek, nebo si koupíš další pokus. Stejná psychologie, ale hlavní hra zůstává bez omezení. |
| Soft → hard currency → consumables | **Zjednodušit na jednu měnu** | Sólo vývojář bez backendu nemá kapacitu ladit dvouvrstvou ekonomiku. Jedna soft měna vydělaná hraním, kterou lze i koupit, stačí. |
| Časově omezené balíčky | **Ano, sezónní palety** | Jednorázová práce (paleta je 7 barev v JSON), opakovaný důvod se vrátit. |
| Personalizované nabídky podle chování | **Ne** | Vyžaduje analytiku a server. Až bude publikum, které to ospravedlní. |
| Reklamy jako vedlejší zdroj | **Zatím ne** | Reklamní SDK znamená síťový kód, ATT dialog, změnu App Privacy z „Data Not Collected“ a konec „no strings“ pozice. Detail v §6. |

Zásadní poučení z Candy Crush, které platí i tady: **hru neplatí většina.**
Model stojí na tom, že hra zůstane pro neplatící kompletní a dobrá, jinak
nezůstanou ani ti, kdo by zaplatili. Puff v tom má výhodu: základní hra je
hotová a nic v ní nemusí zmizet.

## 2. Ekonomický loop Puffu

Candy Crush: životy → zlaté cihly → boostery → nákup.
Puff: **run → Prach → kosmetika a pokusy → nákup Prachu nebo Puff+.**

```
                 ┌──────────────────────────────────────────────┐
                 │                                              │
  run (endless)  ▼                                              │
  ─────────────► skóre ──► PRACH (soft měna) ──► obchod ────────┤
                 │              ▲                 │ palety      │
                 │              │                 │ mraky/stopy │
                 │              │                 │ pokusy DV   │
                 │              │                 ▼             │
                 │        koupit Prach       chce víc / sezóna  │
                 │        (IAP consumable)          │           │
                 │                                  ▼           │
                 └── game over ──► OPRAVIT JÁDRO ◄── Puff+ (IAP non-consumable)
                                   (1× za run)      odemyká všechno najednou
```

### 2.1 Prach (soft měna)

Tematicky sedí: fragmenty pod 0,11 m se už dnes mění v „glowing dust“.
Hráč sbírá to, co rozbije.

- Zisk: `skóre / 100` na konci runu, zaokrouhleno dolů, minimum 1. Bonus
  +25 % za nový rekord v prostředí. Denní výzva dává pevnou odměnu za
  dokončení + bonus za umístění.
- Orientačně: průměrný run 300–800 bodů = 3–8 Prachu; dobrý hráč 2 000+ =
  20+. Cena palety ~150 Prachu = 20–40 runů. Dost dlouho, aby nákup Prachu
  dával smysl, dost krátko, aby se zdarma dalo něco odemknout každý týden.
- Uloženo v `PuffSettings` (`prefs.getInt('dust')`). Bez serveru se dá
  editovat, na tom nezáleží: nic z toho neovlivňuje žebříček.

### 2.2 Co se za Prach kupuje (kosmetika)

Nic z toho nemění fyziku ani skóre, proto to nevadí žebříčkům.

- **Palety.** 6 vestavěných zůstává zdarma. Nové palety po ~150 Prachu,
  sezónní palety (Halloween, zima, jaro) dostupné jen v okně, pak zmizí do
  příštího roku. Výroba jedné palety je hodina práce.
- **Vzhled mraku.** `cloud.frag` má uniformy pro noise a rim, takže
  varianty (jiný swirl, dvojitý rim, „hex“ mřížka, plazmové jádro) jsou
  přepínač v shaderu, ne nový shader.
- **Stopy střepů.** `sparkTrailSpeed` a vykreslování jisker: jiná délka,
  barva z jiné role palety, tečkovaná místo spojité.
- **Vzhled jádra.** Segmenty HP jinak nakreslené.
- **Rázová vlna.** Varianty `shockwave.frag`: dvojitý prstenec, šestiúhelník.

### 2.3 Opravit jádro (continue)

Nejsilnější moment. Pravidla:

- Nabídne se **jen jednou za run** a jen když je skóre alespoň 50 %
  lokálního rekordu pro dané prostředí (jinak to hráče neláká a jen otravuje).
- Cena: 30 Prachu, nebo zdarma s Puff+ (1× za run i pro Puff+, víc by
  rozbilo napětí).
- Obnoví jádro na `Tuning.coreHp`, vyčistí tvary v okruhu 2 m od jádra
  (jinak druhý zásah přijde okamžitě), krátká nezranitelnost 2 s.
- **Žebříček vidí skóre v momentu prvního průlomu jádra.** Lokální rekord
  a Prach počítají celý run. Game Center nemá příznak „s pokračováním“,
  takže tohle je jediný čistý způsob, jak continue prodat a žebříček
  nezkazit. Na game-over obrazovce to musí být řečeno jednou větou.
- Timing nabídky: game-over overlay se zobrazí s tlačítkem OPRAVIT JÁDRO
  nahoře a odpočtem 5 s, po kterém tlačítko zmizí a zůstane běžný
  RESTART / MENU. Odpočet je tlak, ale férový: hráč vidí cenu i skóre.

### 2.4 Denní výzva (náhrada za „čekej, nebo plať“)

`PuffGame(seed:)` už existuje, takže seed = `yyyyMMdd` dává všem stejný
spawn, stejné rychlosti, stejná prostředí. Backend není třeba.

- Jeden pokus denně zdarma. Prostředí a modifikátor se rotují ze seedu.
- Další pokus: 20 Prachu. Puff+: 3 pokusy denně.
- Vlastní Game Center žebříček `puff.daily` (resetuje se denně; Game Center
  „recurring leaderboard“ to umí nativně).
- Boostery jsou povolené jen tady: **Štít proti přetlaku** (jeden fizzle
  odpuštěn), **+2 HP jádra**, **Zpomalení** (5 s na 0,5× rychlosti). Každý
  za 10–15 Prachu, nákup před startem, viditelný v žebříčku jako ikona
  vedle skóre? Game Center to neumí, takže: **boostery = nehodnocený
  pokus**. Hráč si vybere: čistý pokus do žebříčku, nebo boostnutý pokus
  pro Prach a zábavu.
- Bez sítě: pokus se odehraje, skóre se pošle při příští příležitosti
  (`games_services` to řeší samo přes GameKit).

### 2.5 Puff+ (jednorázový nákup)

Pro hráče, kteří nechtějí sbírat ani sledovat měnu. Jeden nákup, všechno.

- Všechny palety včetně sezónních (i mimo okno).
- **Editor palet** (spec §7, nikdy neimplementovaný): vlastní 7 barev,
  export/import JSON. Pro cílovku „minimalist neon“ je tohle hlavní lákadlo.
- Všechny vzhledy mraku / stop / jádra / vlny.
- Opravit jádro zdarma 1× za run, 3 pokusy denní výzvy.
- Trvalý bonus +50 % Prachu.
- Kosmetický odznak u jména? Game Center to neumí, vynechat.

Cena 4,99 € (tier 5). Na App Store se jednorázové „plus“ odemčení
u minimalistických her běžně pohybují 2,99–5,99 €.

## 3. Ceník (SKU)

Držet **maximálně 6 SKU**. Každý další je další review, další screenshot,
další test.

| SKU id | Typ | Obsah | Cena | Role |
|---|---|---|---|---|
| `puff.plus` | non-consumable | viz §2.5 | 4,99 € | hlavní zdroj tržeb |
| `puff.dust.s` | consumable | 200 Prachu | 0,99 € | vstupní nákup, jedna paleta + continue |
| `puff.dust.m` | consumable | 700 Prachu (+40 %) | 2,99 € | nejlepší poměr, „doporučeno“ |
| `puff.dust.l` | consumable | 1 800 Prachu (+80 %) | 6,99 € | pro sběratele palet |
| `puff.tip` | consumable | poděkování, nic ve hře | 1,99 € | pro ty, co „no strings“ oceňují a chtějí to podpořit |
| `puff.season.<rok>` | non-consumable | sezónní balíček 3 palet + 1 mrak | 1,99 € | volitelné, až bude kadence |

Ceny jsou v Apple tierech; Play nastavit stejně. Časově omezená nabídka
„Puff+ za 2,99 €“ první týden po instalaci je jednoduchá varianta
Candy Crush „starter packu“: `firstLaunch` timestamp je v prefs, žádný
server není třeba. App Store Connect umí Introductory offers jen pro
předplatné, takže se to dělá dvěma SKU (`puff.plus` a `puff.plus.intro`)
a klient ukáže jen jeden.

## 4. Tržby: čísla, se kterými počítat

Candy Crush počítá s miliony hráčů. Puff ne. Odhady níže jsou pro sólo
indie hru bez marketingu, ať je vidět, co jaká vrstva reálně dělá.

Předpoklady: 10 000 instalací za rok (organicky Arcade kategorie + jeden
featuring v „New Games We Love“ to zvedne o řád), 30 % podíl Apple/Google
u one-time nákupů (Small Business Program: 15 %, pokud tržby < 1 M $).

| Vrstva | Konverze | Průměrný nákup | Hrubé tržby / 10 k instalací |
|---|---|---|---|
| Puff+ | 2–4 % | 4,99 € | 1 000 – 2 000 € |
| Prach (consumables) | 1–2 % kupujících, 1,8 nákupu | 2,50 € | 450 – 900 € |
| Tip jar | 0,3–0,5 % | 1,99 € | 60 – 100 € |
| Sezónní balíček | 1 % | 1,99 € | 200 € |
| **Celkem** | | | **~1 700 – 3 200 €** |

Po 15 % provizi: **1 450 – 2 700 € ročně na 10 k instalací.** To není
živobytí, to je pokrytí developer účtů a kávy. Živobytí z toho udělá jen
násobek instalací, ne chytřejší ekonomika. Proto §5 řadí kroky podle poměru
práce a efektu a proto se reklamy odkládají: v těchto objemech vydělají
desítky eur a stojí „no strings“.

## 5. Roadmap: co dřív, co potom

Řazeno podle poměru výnos / práce / riziko. Každá fáze je samostatně
vydatelná.

### Fáze A — Puff+ a tip jar (1–2 týdny)

Nejmenší možný krok, který začne vydělávat a otestuje celou infrastrukturu
(StoreKit, Play Billing, review, restore).

1. `in_app_purchase` (Flutter, podporuje SPM od `in_app_purchase_storekit`
   0.3.x, **ověřit před přidáním**, jinak se vrátí Podfile a rozbije CI).
2. `lib/app/store.dart`: načtení produktů, nákup, restore, lokální
   ověření (StoreKit 2 transakce jsou podepsané; bez serveru stačí
   `Transaction.currentEntitlements`). Na Androidu `BillingClient`
   s lokálním ověřením podpisu. Bez serveru = akceptované riziko pirátství;
   u kosmetiky je jedno.
3. `PuffSettings`: `bool plus`, `Set<String> unlocks`, `int dust`.
4. Obsah, který Puff+ musí mít od prvního dne, aby se dal prodat:
   **editor palet** + 6 nových palet + 2 vzhledy mraku. Bez toho není co
   koupit.
5. Menu: tlačítko PUFF+ (neonový styl, ne banner), obrazovka obchodu
   s **Restore purchases** (Apple to vyžaduje).
6. Store listing: přepsat odstavec „NO STRINGS“ (§7).

### Fáze B — Prach a obchod (2 týdny)

1. Výpočet Prachu na konci runu, zobrazení na game-over a v menu.
2. Obchod: palety / mraky / stopy za Prach, consumables `puff.dust.*`.
3. Sezónní palety s datovým oknem (klient má hodiny, server netřeba).

### Fáze C — Opravit jádro (1 týden)

Až je Prach ve hře, continue má čím platit.

1. `PuffGame.repairCore()`: reset HP, vyčištění okolí jádra, i-frames.
2. `ScoreTracker`: zapamatovat `scoreAtFirstBreach` a posílat jen ten do
   Game Center.
3. Game-over overlay s odpočtem, gating na 50 % rekordu.

### Fáze D — Denní výzva (2 týdny)

1. Seed z data, rotace prostředí/modifikátoru ze seedu.
2. Pokusy a jejich cena, boostery jako nehodnocený pokus.
3. Game Center recurring leaderboard `puff.daily` (ručně v App Store
   Connect, stejně jako čtyři stávající).
4. Lokální notifikace „Dnešní výzva: Voda + Magnet“ v 18:00, vypnutelná.
   Jediný retention nástroj, který bez serveru existuje.

### Fáze E — rozhodnutí o reklamách (až po datech)

Jen pokud po 3–6 měsících App Store Connect analytika (bez SDK, Apple ji
dává zdarma) ukáže ≥ 5 000 MAU. Jinak §6.

## 6. Reklamy: proč ne teď

- **Rewarded video za „Opravit jádro“** je jediný formát, který by ve
  hře dával smysl (hráč si ho vybírá sám, dostane hodnotu). Interstitialy
  a bannery jsou u „minimalist neon“ hry sebevražda hodnocení.
- Cena: `google_mobile_ads` = síťový kód, ATT dialog (nebo non-personalized
  ads s nižším eCPM), App Privacy přestává být „Data Not Collected“,
  Android Data safety formulář, privacy manifest, věkové hodnocení 4+ musí
  řešit vhodnost reklamního obsahu. A věta „no ads“ z popisu zmizí.
- Výnos: rewarded eCPM 8–15 € (US/EU), 1 zobrazení denně na 500 DAU = ~5 €
  denně = ~150 € měsíčně. Za rozbití pozice a týden práce.
- Alternativa se stejnou psychologií a nulovou cenou: rewarded moment
  zaplatit Prachem (§2.3). Kdo nemá Prach, dostane nabídku `puff.dust.s`.

Pokud publikum vyroste, rewarded video se přidá **jen** jako alternativní
platba za continue a pokus denní výzvy, nikde jinde, a jen s mediací bez
personalizace. Pak je ATT dialog zbytečný a „no tracking“ zůstává pravda.

## 7. Co monetizace změní mimo kód

- **`store/APP_STORE.md`, odstavec NO STRINGS.** Nový návrh:
  „No account, no ads, no subscription, no tracking. Puff is free and
  complete; Puff+ is a single optional purchase that adds a palette editor,
  more looks and a second chance per run. Your scores never leave your
  device unless you sign in to Game Center.“ Věta „no in-app purchases“ a
  „no network code at all“ musí pryč; StoreKit je síť.
- **App Privacy.** Nákupy přes StoreKit bez vlastního serveru Apple
  nepočítá jako sběr dat vývojářem; „Data Not Collected“ by mělo vydržet,
  **ověřit v aktuálním dotazníku** před submitem.
- **Notes to Review.** Uvést sandbox účet a jak se dostat k obchodu. Review
  IAP testuje.
- **Play Console.** Vytvořit produkty ručně; první AAB s billing
  permission jde znovu přes review.
- **Docs web.** `docs/terms.html` musí zmínit IAP a refundace (Apple/Google
  je řeší, ale podmínky to mají obsahovat).
- **Žebříčky.** Do popisu Game Center žebříčků napsat, že hodnocené skóre je
  před prvním průlomem jádra, jinak přijdou stížnosti „continue mi nepočítá“.

## 8. Co neudělat

- Žádný energy timer, žádný cooldown mezi runy. To je celý pitch hry.
- Žádné placené výhody v hodnoceném skóre.
- Žádné předplatné. Puff nemá obsahovou kadenci, která by ho ospravedlnila,
  a „subscription for a physics toy“ je hodnocení 1★.
- Žádné loot boxy / gacha. Věkové hodnocení 4+, EU regulace, a hlavně
  zbytečné: hráč, který chce paletu, si ji chce vybrat.
- Žádná pop-up nabídka při startu. Obchod je v menu, nabídka continue je
  na game-over, sezónní paleta se ukáže jednou jako neonový řádek v menu.
  Candy Crush si agresivní upsell může dovolit, protože má miliony
  hráčů a ztráta části z nich je statistika. Puff má stovky a každý má
  jméno v žebříčku.

## 9. Otevřené otázky

- Kolik Prachu za run, aby se paleta odemkla za ~30 runů, ale hráč s
  rekordem 3 000 to neměl za 5? Progresivní křivka (`sqrt(skóre)`) místo
  lineární? Rozhodnout po týdnu s telemetrií lokálních skóre (jsou v prefs).
- Continue: 50 % rekordu jako práh, nebo absolutní minimum délky runu
  (90 s)? U nového hráče je rekord nízký a nabídka by chodila pořád.
- Editor palet: vlastní palety sdílet přes JSON v clipboardu stačí? Bez
  serveru není galerie, ale „vlož kód palety“ je zdarma a funguje.
- Puff+ intro cena za dva SKU: stojí to za komplikaci, nebo první měsíc
  prostě nastavit 2,99 € plošně a zvýšit až s Fází D?
