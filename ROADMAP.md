# Puff — ROADMAP: od hračky k živé hře

Otázka zněla: jak z Puffu udělat stejně výdělečnou hru jako Candy Crush. Co
chybí — art, journey, příběh, PR, monetizace, sezóny, eventy, merch?

Tenhle dokument na to odpovídá poctivě. Bere si z Candy Crush **strukturu**
(proč se k ní lidé vracejí a proč platí), ne její čísla. Ekonomiku samotnou
(Puff+, Prach, oprava jádra, denní výzva, SKU, ceník) řeší do detailu
`Prompts/PUFF_MONETIZATION.md` na větvi `claude/puff-monetization-strategy-myujc2`;
tady se na ni odkazuje a nekopíruje.

Stav, ze kterého se vychází: 1.0.4 (září 2026), endless arkáda, čtyři
prostředí, pět modifikátorů, šest palet, Game Center žebříčky na iOS, žádný
backend, žádná analytika, sólo vývoj, veřejný zdrojový kód.

---

## 0. Reality check

Candy Crush Saga není hra, je to organizace. Řádově: přes 20 miliard dolarů
tržeb za životnost, kolem miliardy ročně, přes 15 000 ručně laděných levelů,
tisíce zaměstnanců u Kingu, stovky milionů ročně na nákup hráčů, A/B test na
každém tlačítku a od roku 2012 nepřetržitý live-ops provoz. Její ekonomika
funguje jen proto, že hodnota hráče (LTV) je vyšší než cena jeho nákupu (CPI) —
a **to je jediná věc, kterou sólo vývojář nezreplikuje žádným designem.**

Co se replikovat dá, je pět věcí, které Candy Crush skutečně drží nad vodou,
a žádná z nich není match-3:

1. **Journey** — vždy je další malý cíl a je vidět, jak daleko jsi došel.
2. **Live ops** — hra se mění každý týden, i když ji nikdo neaktualizuje.
3. **Sociální vrstva** — vidíš, kde jsou přátelé, a můžeš je předběhnout.
4. **Brand** — poznáš ji na ikonu, na zvuk, na barvu.
5. **Měření** — každé rozhodnutí je proti číslům, ne proti pocitu.

Puff má z toho dnes 0,5 (žebříčky). Roadmap níže doplňuje zbytek v pořadí,
v jakém to dává smysl pro jednoho člověka, a u každého kroku říká, co stojí a
co by rozbil.

**Reálný strop pro tuhle hru a jednoho vývojáře za 18 měsíců** je řádově
10 000 – 100 000 instalací a jednotky až nízké desítky tisíc eur hrubého.
Skok o řád výš dělá featuring nebo virální klip, ne lepší ekonomika. Proto je
polovina tohohle dokumentu o tom, jak k featuringu a klipu dojít, a druhá o tom,
aby hráči, kteří přijdou, zůstali.

## 1. Co Candy Crush má a Puff ne

| Vrstva | Candy Crush | Puff dnes | Puff v tomto plánu | Cena |
|---|---|---|---|---|
| Journey (progrese) | 15 000+ levelů na mapě, ságový tah „ještě jeden“ | Jeden run, jedno skóre | Režim **Sestup**: 4 světy × 15 levelů, hvězdy, mapa | 6–8 týdnů |
| Příběh / svět | Tiffi a cukrové království, prakticky bez děje | Abstraktní geometrie, jádro uprostřed | Téma sestupu k jádru, jedna věta na level, žádné cutscény | dny |
| Art & brand | Rozpoznatelná ikona, maskoti, hudba, jednotný styl | Silný neon, žádná ikona za peníze, **žádná hudba** | Profesionální ikona + key art, mrak jako značka, ambientní hudba per prostředí, světlé palety | 300–800 € + týdny |
| Ekonomika | Životy → zlaté cihly → boostery | Nic | Puff+, Prach, oprava jádra, kosmetika (viz MONETIZATION) | 4–5 týdnů |
| Live ops | Denní/týdenní eventy, sezónní pass, týmové soutěže | Nic | Denní výzva, týdenní event, **sezóna 6 týdnů** s kosmetickou dráhou | 3 týdny systém + 1–2 týdny/sezóna |
| Sociální vrstva | Přátelé na mapě, životy od přátel, týmy | Game Center žebříčky (jen iOS) | Přátelé v žebříčku ve hře, výzva přes seed, **Play Games na Androidu** | 2–3 týdny |
| Růst (UA) | Stovky milionů za placený marketing | Organic, nulový marketing | Sdílecí karta, featuring, press kit, lokalizace, komunity — **žádná placená akvizice** | průběžně |
| Měření | Vlastní analytika, A/B na všem | Nic | App Store Connect / Play Console analytika, pak privacy-first telemetrie | 0 → 1 týden |
| Tým | Stovky lidí | Jeden | Jeden + freelancer na ikonu/key art | — |
| Merch | Plyšáci, licence, Super Bowl | Nic | Print-on-demand plakáty z vlastního runu, až bude komunita | dny |

## 2. Zásady

Co Puff **drží**, protože to je celý jeho pitch a v kategorii plné Voodoo
klonů jediný diferenciátor:

- Žádný timer na hraní, žádné životy, žádný cooldown. Run začíná vteřinu po
  spuštění.
- Žádné reklamy. Ani rewarded, dokud publikum nepřekročí hranici z §8.
- Žádné placené výhody v hodnoceném skóre. Žebříčky jsou čisté.
- Jeden prst. Žádný tutoriál, který se musí odsedět.
- Žádné předplatné, žádná gacha, žádný pop-up při startu.

Co Puff **pouští**, protože už to není pravda nebo to brzdí:

- „No network code“ padlo s Game Center. „No IAP“ padne s Puff+. Store listing
  se přepisuje jednou, otevřeně (MONETIZATION §7).
- „Endless jako jediný režim“. Endless zůstává domovem značky, ale retenci
  dělá Sestup.
- „Data Not Collected“ bude potřeba přehodnotit s telemetrií (§8). Do té
  doby platí.

## 3. Mezery jedna po druhé

### 3.1 Journey — režim Sestup

Nejdůležitější chybějící vrstva. Endless dává jeden důvod hrát (překonat
skóre) a ten důvod slábne s každým nezdařeným pokusem. Candy Crush dává důvod
každých 90 sekund: další level, další hvězda, další kousek mapy.

**Návrh.** Režim **Sestup**: čtyři světy v pořadí Vakuum → Vzduch → Voda →
Plazma, každý 15 levelů, celkem 60 při vydání. Level je 60–120 s dlouhý,
má cíl, hvězdy a fixní seed.

- **Level je data, ne kód.** JSON: `id`, `world`, `environment`, `modifier`,
  `seed`, `objective`, `spawnScript`, `stars`. Spawner dostane místo rampy
  (`Tuning.spawnInterval*`) skript vln. `PuffGame(seed:)` už existuje.
- **Typy cílů:** *Přežij* (T sekund, jádro musí vydržet), *Skóre* (N bodů na
  K výbuchů), *Přesnost* (rozbij tyhle kovové tvary, omezený počet výbuchů),
  *Purista* (žádný přetlak), *Kolos* (jeden obří polygon, který se musí
  rozlomit třikrát — „boss“, vrchol každého světa).
- **Hvězdy:** 1 = splněno, 2 = jádro bez zásahu nebo ≤ K výbuchů, 3 = obojí
  nebo skóre. Hvězdy jsou měna progrese (odemykají další svět), ne Prach.
- **Každý svět učí jednu věc:** Vakuum slingshot a combo, Vzduch načasování
  proti větru, Voda plánování dvou výbuchů dopředu a vlny, Plazma řetězení
  oblouků. Modifikátory se zpřístupňují postupně, ne všechny na startu.
- **Křivka obtížnosti jako v Candy Crush:** pila, ne rampa. Těžký level
  každých 5–7, za ním oddech. Bez telemetrie se ladí na sobě a na třech
  lidech, s telemetrií podle poměru dokončení (cíl: 70–85 % na běžném levelu,
  30–50 % na těžkém).
- **Mapa.** Nový overlay: čtyři pásy světů, tečky levelů, hvězdy, aktuální
  pozice. Neon, žádná ilustrace. Menu: **PLAY** pokračuje v Sestupu na
  posledním levelu, **ENDLESS** a **DAILY** vedle.
- **Neúspěch = platební moment.** Oprava jádra (MONETIZATION §2.3) v levelu
  nekoliduje s žebříčkem, protože levely žebříček nemají. Tady je continue
  čisté.

**Co to stojí:** spawn skripty, win condition, obrazovka výsledku, mapa,
persistence, 60 levelů ručně naladit. 6–8 týdnů sólo. Nic v `sim/` se
nemění, jen se řídí zvenku.

**Co to rozbije:** nic z pitche. Endless je pořád první věc, kterou hráč může
udělat, jen už není jediná.

### 3.2 Příběh

Candy Crush příběh prakticky nemá a nikomu to nechybí. Co má, je **koherentní
svět**, kterým se postupuje. Puff ho má už v názvech prostředí: sestup
z vakua přes atmosféru a oceán k plazmatickému jádru. Jádro je jediná
„postava“ — má životy a hráč ho chrání.

- Jedna věta na začátku levelu, v neonovém fontu, zmizí s prvním dotykem.
  Šedesát vět. Žádné cutscény, žádné postavy, žádný text delší než řádek.
- Názvy světů a „bossů“ dávají hráčům slova, kterými o hře mluví
  („nemůžu dostat Kolos ve Vodě“). To je pro sdílení víc než děj.
- Pokud se někdy objeví maskot, je to **mrak sám** — už teď je to nejvíc
  rozpoznatelný prvek hry a jediný, který má „chování“ (roste, třese se,
  přetlakuje).

### 3.3 Art & brand

Candy Crush art je světlý, měkký, cukrový — cíleně pro nejširší publikum.
Puff je tmavý neon a abstrakce, což je menší publikum (Duet, Super Hexagon,
Geometry Wars). **Neměnit.** Přebarvit Puff na cukr by ztratilo to, co má, a
jeden člověk art pipeline na úrovni Kingu nepostaví. Co se udělat má:

- **Ikona a key art od profesionála.** Ikona je nejsilnější konverzní prvek
  na store stránce a jediný art, který stojí za peníze. Jednorázově 300–800 €
  za ikonu + tři varianty + key art pro featuring. Předloha: mrak.
- **Světlé palety pro širší publikum.** Dvě až tři pastelové palety
  („Sorbet“, „Paper“, „Dawn“), ať hra nevypadá na screenshotech jen jako
  černá obrazovka. Paleta je 7 barev, hodina práce, a v store screenshotech
  udělá víc než cokoli jiného.
- **Hudba.** Puff ji nemá. Candy Crush má znělku, kterou pozná každý.
  Ambientní vrstva per prostředí — vakuum tichý drone, vzduch pad, voda
  filtrovaný pulz, plazma šum s tóny. `tool/gen_sfx.dart` už syntetizuje
  SFX; hudbu jde generovat stejně, nebo koupit CC0/licenci. Vypínatelná.
- **Screenshoty s textem.** Dnešní store screenshoty jsou čisté záběry.
  Přidat jeden řádek na každý („Hold. Drag. Release.“, „Four worlds.“,
  „Real shatter.“) — `tool/gen_screenshots.sh` a `DemoDriver` to zvládnou.
- **Jednotná sdílecí karta** (§3.7) je zároveň brand asset: stejná typografie,
  stejné umístění loga, paleta hráče.

### 3.4 Ekonomika

Celé v `Prompts/PUFF_MONETIZATION.md`. Shrnutí rozhodnutí, která tenhle plán
přebírá:

- **Puff+** (4,99 €, jednorázově): editor palet, všechny vzhledy, oprava
  jádra zdarma 1× za run, sezónní obsah i mimo okno.
- **Prach** (soft měna z rozbitých tvarů): kosmetika, pokusy denní výzvy,
  oprava jádra. Kupovatelný v třech balíčcích.
- **Oprava jádra**: jednou za run, jen nad 50 % rekordu, žebříček vidí skóre
  před prvním průlomem.
- **Tip jar** pro ty, co „no strings“ oceňují.
- **Bez reklam, bez předplatného, bez energie, bez gachy.**

Co tenhle plán **přidává** nad MONETIZATION:

- **Sezónní dráha** (§3.5) jako čtvrtý důvod k nákupu. Kosmetická, dvě
  úrovně: zdarma (1 paleta + Prach) a plná (součást Puff+, nebo `puff.season`
  za 1,99 €). To je model, na který Candy Crush přešla v posledních letech
  (Season Pass) a který se sólo vývojáři vyplatí víc než consumables.
- **Pořadí:** Sestup **před** ekonomikou. Prodávat continue hráčům, kteří se
  nevrátí, nemá smysl; retence před monetizací je nejstarší lekce F2P.
  Výjimka: Puff+ jako „tip jar plus“ jde pustit kdykoli, stojí týden a
  otestuje StoreKit i review.

### 3.5 Live ops — sezóny a eventy

Candy Crush se mění každý týden a hráč to vidí hned na mapě. Puff se mění,
jen když vyjde verze. Bez serveru se to dá udělat překvapivě daleko:

**Kalendář**

| Rytmus | Co | Jak bez serveru |
|---|---|---|
| Denně | Denní výzva: seed `yyyyMMdd`, rotace prostředí/modifikátoru, 1 pokus zdarma, žebříček `puff.daily` (recurring) | Hodiny v zařízení, `PuffGame(seed:)` |
| Týdně | **Týden prostředí**: dvojnásobný Prach v jednom prostředí, týdenní žebříček `puff.weekly`; nebo **Zkouška modifikátoru** | Seed z čísla týdne |
| 6 týdnů | **Sezóna**: téma, 3 palety, 1 vzhled mraku, 1 varianta pozadí, 10 sezónních levelů, 1 dočasný modifikátor, kosmetická dráha 30 stupňů | Datová okna v klientu, obsah v aplikaci |
| Ročně | 4 sezóny podle kalendáře: podzim/Ember, zima/Arctic, jaro/Acid, léto/Vaporwave | — |

**Remote config za nulu.** Web už běží na GitHub Pages (`docs/`). Soubor
`docs/live/season.json` (aktuální sezóna, eventy, výjimečné dvojnásobky,
zpráva dne) stažený při startu s 24-hodinovou cache a bundlovaným fallbackem
je remote config bez serveru, bez účtu, bez nákladů. Umožní posunout konec
sezóny nebo vypnout rozbitý event bez vydání verze. Je to síťový požadavek na
github.io — do privacy policy jedna věta, GitHub loguje IP podle své politiky.

**Sezónní dráha.** XP = získaný Prach. 30 stupňů, na každém něco: Prach,
paleta, vzhled mraku, stopa. Zdarma dráha dostane každý pátý stupeň, plná
všechno. Kdo nekoupí, o nic nepřijde v hraní — jen v šatníku.

**Notifikace.** Jediná lokální: „Dnešní výzva: Voda + Magnet“ v uživatelem
zvoleném čase, výchozí vypnuto, zapnutí nabídnout po druhé dokončené denní
výzvě. Candy Crush spamuje; Puff si to nemůže dovolit, každý hráč má jméno
v žebříčku.

**Kadence, kterou jeden člověk uhraje:** systém 3 týdny jednorázově, pak
1–2 týdny práce na sezónu (palety, 10 levelů, klip, texty). Čtyři sezóny
ročně je 8 týdnů ročně, zbytek času zůstává na hru.

### 3.6 Sociální vrstva

Candy Crush rostla na Facebooku: mapa s přáteli, životy od přátel. Puff má
Game Center a na Androidu nic.

- **Android parita.** `games_services` umí Play Games Services; `GameCenter`
  dnes vrací `_supported = false` mimo iOS/macOS. Play Console: zapnout Play
  Games, vytvořit čtyři žebříčky, `games-ids.xml`. Polovina instalací může
  být Android a dnes tam soutěžit nejde.
- **Přátelé ve hře.** Systémový žebříček Game Center ukáže přátele, ale až
  po kliknutí. Řádek „přítel X · 2 340 · o 120 víc než ty“ přímo na
  game-over obrazovce je to, co Candy Crush dělá s mapou. `games_services`
  umí načíst skóre; přátelé jsou přes GameKit `loadFriends` (ověřit v plugin
  API, případně jen top-N a vlastní pozice).
- **Výzva přes seed.** „Zahraj můj run“: tlačítko na game-over vygeneruje
  kód (`env-mod-seed`), sdílí se textem. Příjemce zadá kód, hraje stejný
  spawn. Asynchronní duel bez serveru. Universal link (`puff://`) později.
- **Týmy, chat, dárky:** ne. Vyžadují server a moderaci.

### 3.7 Růst — PR, featuring, sdílení

Toto je místo, kde se Candy Crush a Puff liší nejvíc, a proto je tady
nejdelší text. King kupuje hráče: CPI casual hry v USA je jednotky dolarů a
LTV je vyšší, takže každý koupený hráč vydělá. Puff bude mít LTV řádově
desítky centů (MONETIZATION §4). **Placená akvizice je pro Puff ztráta o řád
a v tomto plánu není.** Zbývá organický růst, a ten má u téhle hry jednu
obrovskou výhodu: **výbuchy jsou vizuálně unikátní a trvají tři sekundy.**
To je přesně formát krátkého videa.

**Sdílecí smyčka (nejvyšší priorita v růstu)**

- **Karta výsledku.** Po runu jedno tlačítko: snímek posledního výbuchu
  (pipeline post-processu už rasterizuje scénu do `ui.Image`) + skóre,
  prostředí, paleta, logo, jeden řádek. Sdílet přes systémový sheet
  (`share_plus`, ověřit SPM). Vypadá stejně jako store screenshoty, protože
  je to tentýž brand.
- **Tapeta z runu.** Stejná karta bez textu v rozlišení displeje. Zdarma.
  Každá tapeta na cizím telefonu je reklama, která nic nestojí.
- **Klipy pro sociální sítě generuje `DemoDriver`.** `PUFF_DEMO` už dnes
  dělá skriptované doteky pro screenshoty. Rozšířit o export sekvence
  snímků → ffmpeg → 9:16 klip. Jeden klip na sezónu, jeden na každý nový
  modifikátor. Vlastní nahrávání hráčem (ReplayKit) až později; nejdřív se
  musí ukázat, že klipy vůbec fungují.

**Featuring**

- Apple: formulář **Nominate for featuring** v App Store Connect
  (Promote → Nominations), s předstihem 2–3 týdny před vydáním verze.
  Puff je přesně typ hry, kterou editoriál bere (premium pocit, žádné
  reklamy, custom shadery, Impeller). Podat při každé sezóně. Jedno
  „New Games We Love“ je řádový skok v instalacích a nejpravděpodobnější
  cesta z 10 k na 100 k.
- Google: Play Console → *Indie Games* programy a featuring nominace.
- Flutter/Flame: **Flame showcase** a Flutter „Made with Flutter“ — reálný
  distribuční kanál mezi vývojáři, kteří tweetují. Puff je jedna z mála
  Flame her s vlastním post-processem na Impelleru; to je článek sám o sobě.

**Press kit a dev content**

- `docs/press/`: ikona, key art, 6 screenshotů, 2 klipy, fact sheet, kontakt.
  Formát presskit(). Bez toho žádný web o hře nenapíše.
- **DEVLOG je hotový obsah.** „Jak funguje fraktura konvexních tvarů“, „Proč
  jsme šli z Box2D na v3“, „Ripple v q-space“ — to jsou články pro
  Hacker News („Show HN: open source neon physics game in Flutter“),
  r/gamedev, r/FlutterDev. Open source je tady marketingová výhoda, ne
  slabina.
- Cíle pro mail (5 kusů, ne 50): TouchArcade, PocketGamer, AppAdvice,
  iMore/9to5Mac „apps of the week“, jeden český web (Letem světem Applem /
  Jablíčkář). Jedna sezóna = jeden mail.
- Komunity: r/iosgaming, r/AndroidGaming, r/indiegaming, Product Hunt
  jednou při Sestupu.

**Lokalizace (podceňované)**

- UI má ~40 řetězců. `flutter_localizations` + `.arb`, 10 jazyků
  (EN, CS, DE, FR, ES, IT, PT-BR, JA, KO, ZH-Hans) za den práce a strojový
  překlad s kontrolou.
- **Lokalizovaný store listing** je důležitější než lokalizované UI: App
  Store hledá v metadatech daného trhu. Popis a klíčová slova do stejných
  10 jazyků zvednou dosah, který nic jiného za den práce nezvedne.

**Hodnocení**

- `in_app_review` (ověřit SPM): vyzvat po třetím „NEW BEST“ nebo po
  dokončení světa, nikdy na game-over po špatném runu. Hodnocení řídí
  pořadí ve vyhledávání a konverzi store stránky.

**Co se PR týče a v plánu není:** placené reklamy, influencer kampaně za
peníze, cross-promo sítě, ASO nástroje za předplatné. Až s čísly, která to
zaplatí.

### 3.8 Měření

Candy Crush se rozhoduje podle dat. Puff nemá data a bez nich je každý krok
níže sázka.

**Fáze 0 — zdarma, bez SDK:** App Store Connect → App Analytics (instalace,
sessions, retence D1/D7/D30, crashes, zdroje) a Play Console (stejné +
Android vitals). Stačí na první brány.

**Fáze 1 — privacy-first telemetrie:** až Sestup poběží. Kandidát
TelemetryDeck (anonymní, bez identifikátorů, GDPR bez souhlasu; ověřit SPM
Flutter SDK). Události: level start/finish/fail, počet výbuchů, přetlaky,
oprava jádra nabídnuta/přijata, obchod otevřen, nákup. **Bez toho se nedá
ladit křivka obtížnosti a bez křivky obtížnosti nefunguje Sestup.** Změní
App Privacy na „Data Collected: Usage Data, not linked to you“; „no tracking“
zůstává pravda a musí zůstat.

**Fáze 2 — A/B:** ne. Bez desítek tisíc MAU nemá statistickou sílu.

### 3.9 Merch a rozšíření značky

Pro Candy Crush je merch licenční byznys. Pro indie je merch **brand, ne
výnos**, a dává smysl teprve s komunitou (≥ 50 k instalací, aktivní
žebříčky). Pak, s nulovým skladem (print-on-demand):

- **Plakát z vlastního runu.** Sdílecí karta ve 300 dpi bez UI, koupitelná
  jako tisk. Unikátní produkt: nikdo jiný ten výbuch nemá. Technicky je to
  export z hry + odkaz na POD službu.
- **Šest palet jako šest tisků.** Barevná pole s názvem palety, čistý design.
- **Odznak mraku.** Až bude ikona od profesionála.
- **Soundtrack** na Bandcampu, až bude hudba.
- **Tapety zdarma** hned — to je merch, který dělá reklamu.

### 3.10 Alternativní cesta: Apple Arcade, Netflix Games, Steam

Puff se svou „no strings“ pozicí sedí do katalogu Apple Arcade nebo Netflix
Games lépe než do F2P světa Candy Crush: kurátorované, bez IAP, bez reklam,
placené paušálem a za zapojení hráčů. Dostat se tam je těžké a vyžaduje
exkluzivitu (Arcade verze bez IAP vedle store verze je běžná praxe:
„Puff+“ jako Arcade edice). Stojí to jeden pitch mail s press kitem a
klipem — podat po vydání Sestupu, protože katalogy chtějí vidět obsah.

Steam (Flutter desktop + Flame) je technicky dosažitelné, ale jiný trh,
jiné ovládání (myš místo prstu) a jiný marketing. Zapsat jako možnost pro
rok 2, ne dřív.

## 4. Fáze

Každá fáze je samostatně vydatelná a má výstup, který se dá změřit.

### Fáze 0 — Základy růstu (týdny 1–4)

Nic z toho nevyžaduje design, všechno zvedá dosah dnešní hry.

- App Store Connect / Play Console analytika: zapnout, číst týdně.
- Sdílecí karta + tapeta z runu.
- `in_app_review` prompt.
- Lokalizace UI a **store listingu** do 10 jazyků.
- Ikona a key art od freelancera (zadat teď, hotové do Fáze 1).
- Dvě světlé palety.
- Press kit v `docs/press/`, jeden článek z DEVLOGu na HN / r/gamedev.
- Android: Play Games Services žebříčky (parita s iOS).
- Featuring nominace pro 1.1 (s Sestupem) podaná s předstihem.
- Sloučit `Prompts/PUFF_MONETIZATION.md` do masteru.

**Výstup:** 1.0.x, první retenční čísla (D1/D7), press kit, klip.

### Fáze 1 — Sestup (měsíce 2–4)

- Level formát, spawn skripty, cíle, hvězdy, mapa, výsledek levelu.
- 60 levelů, 4 světy, 4 Kolosy, 60 vět.
- Hudba per prostředí (vypínatelná).
- Telemetrie levelů (TelemetryDeck nebo ekvivalent).
- Vydání jako **1.1** s featuring nominací, Product Hunt, mail 5 webům, klip.

**Výstup:** D7 retence před/po; poměr dokončení per level.

### Fáze 2 — Ekonomika (měsíce 4–6)

MONETIZATION Fáze A–C: Puff+ s editorem palet, Prach, obchod, oprava jádra.
Store listing a docs přepsané. Sandbox účet pro review.

**Výstup:** konverze na Puff+, ARPU, podíl continue.

### Fáze 3 — Live ops (měsíce 6–9)

- Denní výzva (`puff.daily`), týden prostředí (`puff.weekly`).
- Remote config `docs/live/season.json`.
- **Sezóna 1** (6 týdnů): téma, 3 palety, mrak, 10 levelů, dráha 30 stupňů.
- Lokální notifikace, opt-in.

**Výstup:** DAU křivka v týdnu, podíl hráčů denní výzvy, prodej dráhy.

### Fáze 4 — Sociální vrstva a druhý dech (měsíce 9–12)

- Přátelé na game-over, výzva přes seed.
- Sezóna 2 a 3. Každá s klipem, mailem, nominací.
- Pitch Apple Arcade / Netflix Games s čísly ze Sestupu.

### Fáze 5 — Značka (12+ měsíců, podmíněně)

Merch přes POD, soundtrack, případně Steam. Jen pokud §5 říká ano.

## 5. Brány

Bez čísel se nepokračuje do další fáze; s čísly pod hranicí se dělá to, co
je v posledním sloupci.

| Metrika | Casual benchmark | Brána | Když ne |
|---|---|---|---|
| D1 retence po Fázi 0 | 30–40 % | ≥ 25 % | Onboarding: první run musí skončit úspěchem; zkrátit menu |
| D7 po Sestupu | 10–15 % | ≥ 10 % | Křivka obtížnosti, první svět příliš dlouhý/těžký |
| Dokončení levelu | 70–85 % běžný, 30–50 % těžký | v pásmu | Přeladit spawn skript daného levelu |
| Konverze Puff+ | 2–4 % | ≥ 2 % | Obsah Puff+ není vidět; editor palet do menu |
| Podíl denní výzvy | — | ≥ 15 % DAU | Výzva je schovaná, nebo bez odměny |
| MAU pro reklamy (rewarded jen za continue) | — | ≥ 5 000 | Nepřidávat |
| Instalace pro merch | — | ≥ 50 000 | Nepřidávat |
| Featuring | — | 1× do 12 měsíců | Nominovat znovu s každou sezónou, přepracovat key art |

Orientační žebřík tržeb (hrubé, ARPU 0,2–0,4 € s Sestupem a sezónami; odhad,
ne měření):

| Instalací za rok | Hrubé tržby | Co k tomu vede |
|---|---|---|
| 10 000 | 2–4 tis. € | Dnešní organická trajektorie + Fáze 0–2 |
| 100 000 | 20–40 tis. € | Jeden featuring nebo virální klip + sezóny |
| 1 000 000 | 200–400 tis. € | Opakovaný featuring, lokalizace, Android parita, druhá platforma; **vyžaduje backend, analytiku a druhého člověka** |
| Candy Crush | ~1 mld. $ | Organizace s tisíci lidmi a rozpočtem na UA |

## 6. Co nedělat

Přebírá MONETIZATION §8 a přidává:

- **Neměnit art na cukr.** Puff prodává neon; přebarvení ztratí publikum,
  které má, a nezíská to, které má Candy Crush.
- **Nepřidávat postavy a cutscény.** Jedna věta na level. Hra se jmenuje
  podle mraku, ne podle hrdiny.
- **Nestavět backend před 50 k MAU.** Remote config přes GitHub Pages a
  Game Center pokryjí všechno v tomto plánu.
- **Nekupovat instalace.** LTV je o řád pod CPI.
- **Nedělat energii, životy ani timer.** Ani „jen v Sestupu“. Jakmile je
  jeden režim zamčený časem, hráč si pamatuje hru jako zamčenou.
- **Nesledovat hráče.** Telemetrie ano, identifikátory ne. „No tracking“ je
  věta, která musí zůstat pravdivá v každé verzi.
- **Nezaplavovat notifikacemi.** Jedna denní, opt-in, s vlastním časem.
- **Nedělat 6 sezón ročně.** Čtyři jsou pro jednoho člověka strop, a raději
  tři dobré než čtyři odbyté.

## 7. Prvních 30 dní

Konkrétně, v pořadí:

1. Zapnout a přečíst App Store Connect App Analytics a Play Console za 1.0.x.
   Zapsat D1/D7 jako nulový bod.
2. Sloučit monetizační větev do masteru.
3. Zadat ikonu + key art freelancerovi (brief: mrak, neon, čitelné v 60 px).
4. Sdílecí karta + tapeta z runu → 1.0.5.
5. `in_app_review` po třetím NEW BEST → 1.0.5.
6. Lokalizace UI + store listingu (10 jazyků) → 1.0.5.
7. Play Games Services žebříčky na Androidu → 1.0.5.
8. `docs/press/` press kit, dva klipy z `DemoDriver`.
9. Jeden článek z DEVLOGu (fraktura nebo ripple) na HN a r/gamedev.
10. Nominace na featuring pro 1.1 s termínem za 10 týdnů.
11. Začít Sestup: level formát a první svět.

## 8. Otevřené otázky

- **Sestup a endless v jednom skóre?** Ne — endless drží žebříčky, Sestup
  drží hvězdy. Ale má Sestup vlastní žebříček „součet hvězd“? Game Center to
  umí; rozhodnout po prvním světě.
- **Kolik levelů na vydání 1.1?** 60 je hodně na ruční ladění bez dat.
  Alternativa: 30 (dva světy) a druhé dva světy jako Sezóna 1. Menší riziko,
  dřívější data.
- **Hudba generovaná nebo licencovaná?** Generovaná sedí k tomu, jak vznikly
  SFX, a obchází licenční otázky u klipů na sociálních sítích. Ale ambient
  bez hudebníka může znít lacině. Zkusit jeden track, rozhodnout podle ucha.
- **Telemetrie a „Data Not Collected“.** Jak moc hráčů odradí změna
  v App Privacy? Casual hráči si toho nevšimnou; publikum Puffu (kdo čte
  „no strings“) možná ano. Zvážit telemetrii jako opt-in v Settings s
  výchozím zapnuto a jasnou větou. Ověřit, zda Apple opt-in respektuje
  v dotazníku.
- **Kdy druhý člověk?** Pravděpodobně nikdy na plný úvazek při 10–100 k
  instalací. Freelancer na art ano, na level design ne (levely jsou design
  hry a ten je vývojářův).
