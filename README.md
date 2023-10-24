# FoodScannerApp

##Functions:

Sensorik:
- Barcode Scanner => Kamera

- Authentification:
  => Fingerprint, FaceId (Turn off/on in Settings) => https://pub.dev/packages/local_auth

Aktorik:
- Vibration
- Notificationsound

Notificationfunction:
https://pub.dev/packages/flutter_local_notifications

Network communication:
Api => https://de.openfoodfacts.org/ || https://pub.dev/packages/openfoodfacts

##Pages:
1) Authentification-Page
2) Shopping list-Page
3) Scanner-Page
4) Product Info-Page
5) Add product manually-Page
6) Settings-Page

#Wichtig für die Programmierung:
- Verwenden von Konstanten in flutter ist sehr wichtig für die Performance
- Verwenden von Einheitlichen Komponenten (In Flutter sind diese Vorgegeben meistens, am besten diese auch verwenden)
- Auslagerung so viel wie möglich
- Die Verzeichnisse dementsprechend wählen und benennen
- Bei Booleans immer isTall, isSmall, is...

Datenbank: Firebase nur als Datenbank
Gruppenmanagment -> Usermanagment -> Fingerprint/FaceID Token


SettingsPage:
Theme Farbauswahl (8 Farben),
Abmelden fixen,
Konto löschen Button mit Nutzerbestätigung.
Buttons in einer Card setzen,
Titel setzen,
Möglichkeit zwischen Home und settings zu swipen (nach merge)
Fingerprint/FaceID nach Betriebssystem definieren,
Accountspezifische Einstellungen (Password/Email ändern)
Ton/Vibration ein/aus


