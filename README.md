# Steppy

## Description
Steppy is an experimental project designed to intercept and modify step count data retrieved by iOS applications, including those using HealthKit and Flutter. By hooking into the relevant APIs and method calls, this tweak artificially increases the number of steps reported to the app, enabling advanced testing, research, and demonstration scenarios where manipulated health data is required. 

Please note that this project is intended solely for research and educational purposes. The author does not endorse or encourage any misuse of this software, and expressly disclaims all liability for any consequences arising from its use. Use Steppy responsibly and at your own risk.

**Important:** Unless you are using Steppy as an injected IPA, you must specify the bundle ID of the app you want to spoof step counts for in `Steppy.plist`. Otherwise, the tweak will not be applied to your target app.

We welcome contributions from the community! If you have suggestions, improvements, or bug fixes, feel free to submit a pull request. For inquiries or updates, connect with the author on Twitter: [@ChromiumCandy](https://twitter.com/ChromiumCandy)

---

## How It Works

### HealthKit Hook
Steppy hooks into HealthKit's APIs to intercept requests for step count data. When an app queries HealthKit for step counts, the tweak replaces the returned value with a fixed, large number (e.g., 10,000 steps). This is achieved by hooking methods such as `HKSampleQuery` and `HKStatistics`, ensuring that any step count data retrieved by the app is artificially increased. This allows for testing and demonstration of apps under conditions with manipulated health data.

### Flutter Hook
For apps using Flutter, Steppy hooks into the relevant plugin methods that provide health data. When the app requests step data via Flutter, the tweak intercepts the response and adds a significant number of steps to the original value. This ensures that both native and Flutter apps receive inflated step counts, regardless of the underlying implementation.

---

## 説明
Steppyは、iOSアプリ（HealthKitやFlutterを利用するものを含む）が取得する歩数データをインターセプトし、改変するための実験的なプロジェクトです。関連するAPIやメソッドコールをフックすることで、アプリ側に報告される歩数を人工的に増加させ、テスト・研究・デモンストレーションなど、改変されたヘルスデータが必要な場面で活用できます。

本プロジェクトは研究および教育目的のみを意図しています。作者は本ソフトウェアの不適切な利用を推奨・容認するものではなく、使用に伴ういかなる損害・結果についても一切の責任を負いません。Steppyの利用は自己責任で、責任ある方法でご利用ください。

**注意:** injected IPAとして利用する場合を除き、偽装したいアプリのバンドルIDを`Steppy.plist`に必ず記載してください。これを記載しないと、対象アプリにTweakが適用されません。

コミュニティからの貢献を歓迎します！ご提案・改善・バグ修正などがあれば、ぜひプルリクエストをご提出ください。ご質問や最新情報は、作者のTwitter [@ChromiumCandy](https://twitter.com/ChromiumCandy) までお気軽にご連絡ください。

---

## 仕組み

### HealthKitのhook
Steppyは、HealthKitのAPIにフックし、歩数データの取得要求をインターセプトします。アプリがHealthKitに歩数を問い合わせると、Tweakが返却値を固定の大きな数値（例：10,000歩）に置き換えます。`HKSampleQuery`や`HKStatistics`などのメソッドをフックすることで、アプリが取得する歩数データが常に改変されるようになっています。これにより、改変されたヘルスデータ環境下でのアプリのテストやデモが可能です。

### Flutterのhook
Flutterを利用するアプリに対しては、関連するプラグインのヘルスデータ取得メソッドをフックします。アプリがFlutter経由で歩数データを要求した際、Tweakがレスポンスをインターセプトし、元の値に大幅な歩数を加算して返します。これにより、ネイティブ・Flutter双方のアプリで歩数データが水増しされることを保証します。


ChatGPT generated as always XP