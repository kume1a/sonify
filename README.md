# Sonify

Music streaming app<br>

Connect to spotify your account, import playlists, download Youtube audios, upload your local music.
<br>
Upon application launch your saved audios are synced to the server so you'll keep your local 
downloaded audios after device change.  

### Invite link
https://appdistribution.firebase.dev/i/9438bda8d8d6d57a

## Launching the project

Get packages and generate code
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cd packages/domain_data
dart run build_runner build --delete-conflicting-outputs
cd ../sonify_client
dart run build_runner build --delete-conflicting-outputs
cd ../sonify_storage
dart run build_runner build --delete-conflicting-outputs
cd ../..
```

Run it
```
flutter run
```

Build apk
```
flutter clean 
flutter pub get
flutter build apk
```
