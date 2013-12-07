# my-socket-io-sample

## 単純なルーティングアプリ作成時の学習事項

* path モジュールの basename メソッドを使って、request オブジェクトに格納されたリクエスト URL から basename を抽出します。
* 抽出された basename はそのままでは URL エンコードされているので、lookup 変数に格納する際に decodeURI でデコードします。デコードを忘れてしまうと、本来評価すべき basename の値が "another page" だった場合に半角スペースが %20(URL エンコードされた空白文字)のままとなり、
* "another%20page" という文字列が評価に利用されます。その結果、意図している文字列 "another page" とはマッチせず、false が返されてしまいます。

* forEach は _.each で。

```
_.each [ 1, 2, 3 ], (num) -> show num
_.each {one : 1, two : 2, three : 3}, (num, key) -> show num
```

* if type of "funciton" は _.result で。
* [アンスコJSの _.result は、関数だったら実行して、変数だったらそのまま返す関数 - わからん](http://d.hatena.ne.jp/kitokitoki/20131207/p2)
* [forEach のコールバックはループの実行中はブロックされている - わからん](http://d.hatena.ne.jp/kitokitoki/20131124/p1)

## 参考資料、引用資料

* [Nodeクックブック](http://www.oreilly.co.jp/books/9784873116068/)
