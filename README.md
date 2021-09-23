# クラウドクローゼット(ManageClothesUIkit)

## アプリ概要
服を管理できるシンプルなアプリです。

開発言語はSwift、サーバーはFirebaseを利用しています。

App Store: [クラウドクローゼット](https://apps.apple.com/jp/app/id1573709222)

## アプリの作成背景
2021年の6月に上京することが決定したときに、どの服を持っていくかについて迷いました。

その理由が、自分が持っている服を管理できていなかったからです。

そこで、自分で服を管理する専用をアプリを作成しようと考えました。

デフォルトで入っている写真のアルバムでも良いと思いましたが、それではライブラリから削除するとアルバムからも消えてしまいます。

僕は服の写真をライブラリに残したくないため、あえてアプリを作成しました。

## アプリで使用しているライブラリ
### CocoaPods
・Firebase/Auth
・Firebase/Firestore
・Firebase/Storage
・SDWebImage

### Swift Package Manager
・[RXSwift](https://github.com/ReactiveX/RxSwift)
・[PKHUD](https://github.com/pkluz/PKHUD)
