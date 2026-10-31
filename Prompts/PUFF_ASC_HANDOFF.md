# Handoff pro Claude v Chrome — App Store Connect, Puff 1.2.2

Vlož celé do Claude v Chrome (v okně, kde je App Store Connect přihlášený).

---

Pracuješ v App Store Connect na aplikaci **Puff: Pressure Blast** (bundle
`com.ol1n.puff`, Apple ID 6808586613). Cíl: zlepšit poměr zobrazení →
návštěva stránky v USA z 0,6 % na ≥ 3 %. Všechny texty jsou v repu
`~/Dev/GitHub/puff` v `store/APP_STORE.md`, sekce **ASO — 1.2.2**. Kopíruj je
přesně odtud, nic nepřepisuj.

Před každým odesláním (Save u textů, Submit for Review, Start Test) mi napiš,
co přesně odešleš, a počkej na moje „ano“.

## Krok 1 — Promo text (hned, bez nové verze)

*App Store → aktuální živá verze → English (U.S.) → Promotional Text* →
vlož promo text ze sekce *Promotional Text (170)*. Ulož.

## Krok 2 — Verze 1.2.2 (až bude build 1.2.2 zpracovaný)

Podmínka: v *TestFlight* je build verze **1.2.2** ve stavu Ready. Pokud
není, skonči a napiš mi to.

1. *App Store → + Version* → `1.2.2`.
2. *Build* → vyber build 1.2.2.
3. English (U.S.):
   - **Subtitle** a **Keywords** ze sekcí *Subtitle (30)* a *Keywords (100)*.
     Subtitle a Keywords se nastavují u verze/App Information podle toho, kde
     je ASC zrovna má; zkontroluj počty znaků po vložení.
   - **What's New** ze sekce *What's New (1.2.2)*.
   - **Screenshots, iPhone 6.9"**: nahraj tři soubory z
     `build/store_shots/en-US/` (`1_blast.png`, `2_combo.png`,
     `3_calm.png`) a přetáhni je na **pozice 1–3** před stávající
     screenshoty. Stávající nemaž. iPad nech beze změny.
   - **App Preview, iPhone 6.9"**: `build/app_preview/puff_preview_886x1920.mp4`,
     pokud soubor existuje (jinak přeskoč a napiš mi). Poster frame = výbuch.
4. Pro lokalizace **en-GB, en-CA, en-AU, de-DE, fr-FR, es-MX, pt-BR, ja,
   ko**: stejně, soubory z `build/store_shots/<locale>/` na pozice 1–3.
   Pokud lokalizace v ASC neexistuje, nevytvářej ji — napiš mi.
5. Zkontroluj, že nic nehlásí chybu, a teprve po mém souhlasu
   *Add for Review → Submit*.

## Krok 3 — A/B test (až bude 1.2.2 živá)

*Product Page Optimization → Create Test*:

- Název `Icon + captions 2026-11`, 3 treatmenty, 100 % provozu, všechny
  lokalizace, délka podle odhadu ASC (min. 14 dní).
- Treatment A: ikona **AppIcon-Blast** + nové screenshoty.
- Treatment B: ikona **AppIcon-Cloud**.
- Treatment C: ikona **AppIcon-Shatter**.
- Start testu až po mém souhlasu.

## Na konci

Napiš mi: co je uložené, co odeslané, co přeskočené a proč, a stav review.
Do repa nic nezapisuj.
