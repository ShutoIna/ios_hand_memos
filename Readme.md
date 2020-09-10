#ios用mediapipeのmultihandtracking設定について

以下のページを参照してください
大まかな進め方(versionによる多少の違いあり)<https://qiita.com/yamatohkd/items/0f5b9b031ec0976d872a>
Xcode設定方法<https://dev.classmethod.jp/articles/run-on-devices-without-apple-developer-program-license/>
BundleID取得方法<https://qiita.com/BMJr/items/ff51f9fa4d8eab957222>
実機の確認方法<https://i-app-tec.com/ios/device-test.html>
データの保存先について<https://teratail.com/questions/194427>

3D座標の取得は，~/mediapipe/mediapipe/examples/ios/multihandtrackinggpu/MultiHandTrackingViewController.mm　を上のファイルに書き換えてください
