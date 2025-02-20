# ShopTogether

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
- Theme Farbauswahl (8 Farben),
- Möglichkeit zwischen Home und settings zu swipen (nach merge)
- Accountspezifische Einstellungen
 - Konto löschen Button mit Nutzerbestätigung.
 - Passwort/Email/Name ändern lasen

Booleans in einer Liste einpacken im Provider (for Schleife) mit update funktion (i)

Entfernung von Email in der Anmeldungsseite per button
Beim registrieren weiteres Feld "Passwort wiederholen"
Produkte Leuten zu weisen

Neues Theme für Anmeldeseite mit Weissem Hintergrund, Title theme für andere seiten transparent machen

![Screenshot_20250220_231515](https://github.com/user-attachments/assets/fe73add3-4079-4306-a5e8-66c1a69f23f9)
![Screenshot_20250220_231523](https://github.com/user-attachments/assets/d6dafb21-d2fb-4883-93d0-8e8a8f89378f)
![Screenshot_20250220_231633](https://github.com/user-attachments/assets/316397b6-43ec-4296-9632-1a40997976d3)
![Screenshot_20250220_231624](https://github.com/user-attachments/assets/a390f693-66dc-4a20-8c6d-5be1a7e477a0)


