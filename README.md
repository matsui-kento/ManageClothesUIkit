# クラウドクローゼット(ManageClothesUIkit)

## アプリ概要
服を管理できるシンプルなアプリです。

開発言語はSwift、サーバーはFirebaseを利用しています。

このサービスは実際にリリースしましたが、2人しかダウンロードされずに、悔しい思いをしました。

そこで、まだコードには落とし込めていませんが、「服　管理」のワードで上位を占めているアプリを調べて、なぜこのアプリが使われないのか調査しようとしています。

App Store: [クラウドクローゼット](https://apps.apple.com/jp/app/id1573709222)

### テストユーザー
email: user1@gmail.com

password: 123456

＊アプリをどんなものが触りたいけど、メールアドレスは登録したくないという方はお使いください。

---
## 登録した写真を見る→写真を消す
https://user-images.githubusercontent.com/69304437/135024672-3dd4738e-214c-4c71-b5b1-8cf8e4392e6e.mp4



## ログイン→写真を登録する
https://user-images.githubusercontent.com/69304437/135074686-2b1124f8-28f4-4122-aa01-9e35e0f0c49b.mp4

---

## アプリの利用画面
![1](https://user-images.githubusercontent.com/69304437/135024494-9c47c7cb-6a9a-42d1-ba56-d0eaa29455dd.png)
![2](https://user-images.githubusercontent.com/69304437/135024538-f08cc1db-6652-4375-88f1-11fe69ac167a.png)
![3](https://user-images.githubusercontent.com/69304437/135024542-fe2cf8bb-735e-42e2-8762-1b513fe68f2b.png)

---

## アプリの作成背景
2021年の6月に上京することが決定したときに、どの服を持っていくかについて迷いました。

その理由が、自分が持っている服を管理できていなかったからです。

そこで、自分で服を管理する専用をアプリを作成しようと考えました。

デフォルトで入っている写真のアルバムでも良いと思いましたが、それではライブラリから削除するとアルバムからも消えてしまいます。

僕は服の写真をライブラリに残したくないため、あえてアプリを作成しました。

---

## アプリで使用しているライブラリ
### CocoaPods
- [Firebase/Auth](https://github.com/firebase/firebase-ios-sdk)

- [Firebase/Firestore](https://github.com/firebase/firebase-ios-sdk)

- [Firebase/Storage](https://github.com/firebase/firebase-ios-sdk)

### Swift Package Manager
- [RXSwift](https://github.com/ReactiveX/RxSwift)

- [PKHUD](https://github.com/pkluz/PKHUD)

- [SDWebImage](https://github.com/SDWebImage/SDWebImage)
