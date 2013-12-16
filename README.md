# my-socket-io-sample

## [TAG:SimpleHttpServer](https://github.com/mori-dev/my-socket-io-sample/tree/SimpleHttpServer)

* server.listen() を加えると、ハンドルの登録が行われイベントループが維持される
* [node.js のハンドルとは何かのメモ - わからん](http://d.hatena.ne.jp/kitokitoki/20131130/p2)
* (Node では 1箇所でも重い処理(CPU ヘビーな処理)があると、全体のパフォーマンスが低下してしまう)

## [TAG:SipmleRoutingApplication](https://github.com/mori-dev/my-socket-io-sample/tree/SipmleRoutingApplication)

* path モジュールの basename メソッドを使って、request オブジェクトに格納されたリクエスト URL から basename を抽出します。
* 抽出された basename はそのままでは URL エンコードされているので、lookup 変数に格納する際に decodeURI でデコードします。デコードを忘れてしまうと、本来評価すべき basename の値が "another page" だった場合に半角スペースが %20(URL エンコードされた空白文字)のままとなり、"another%20page" という文字列が評価に利用されます。その結果、意図している文字列 "another page" とはマッチせず、false が返されてしまいます。
* forEach は _.each で。

```
_.each [ 1, 2, 3 ], (num) -> show num
_.each {one : 1, two : 2, three : 3}, (num, key) -> show num
```

* if type of "funciton" は _.result で。
* [アンスコJSの _.result は、関数だったら実行して、変数だったらそのまま返す関数 - わからん](http://d.hatena.ne.jp/kitokitoki/20131207/p2)
* [forEach のコールバックはループの実行中はブロックされている - わからん](http://d.hatena.ne.jp/kitokitoki/20131124/p1)

## [TAG:SipmleStreamingApplication](https://github.com/mori-dev/my-socket-io-sample/tree/SimpleStreamApplication)

* fs.createReadStream でストリームを開始、そのストリームを response オブジェクトに pipe で送ります
* stream.pipe はストリームが終了すると自動的に response.end を呼び出します。だから、end を書いていません

```
fs.createReadStream(file).once 'open', ->
  response.writeHead 200, headers
  @pipe response
```

* readStream はストリームのさまざまな場面でイベントを発行します。open イベントなど。
* on でイベントハンドラを設定します。
* イベントハンドラの処理が終わった後に、そのイベントリスナを保持しておく必要がない場合は once でイベントハンドラを設定します。

```
stream = fs.createReadStream(file).once 'open', ->
  response.writeHead 200, headers
  @pipe response
.once 'error', (error) ->
  console.log(error)
```

### ストリームの基礎知識

* ストリームでは、入出力データはバッファ単位でストリーム上を行きかいます。
* ストリームは EventEmitter のインスタンスで、だから、状態の変更がイベントによって通知されます。
* 入力ストリーム(Readable Stream) は、data、end、close、error イベントを発生します。
* 読み込みが開始されると data イベントが発生します。
* 入力が終了し、data イベントが発生しなくなると end イベントが生成され、ファイル記述子が閉じられた段階で close イベントが発生します。この close イベントはすべてのストリームで発生するわけではありません。
* pipe(destination, [options]) というメソッドがあります。出力ストリームに入力ストリームを接続します。読み込まれたデータは接続された出力ストリームに書き込まれます。destination には出力ストリームを指定します。
* 出力ストリーム(Writable Stream)は、drain、end、close、error イベントを発生します。
* drain イベントは書き込み再開できるようになったときに発生します。
* pipe イベントは出力ストリームが入力ストリームの pipe() に渡されると発生します。

## [TAG:SimpleSocketIOApplication](https://github.com/mori-dev/my-socket-io-sample/tree/SimpleSocketIOApplication)

* クライアント用の socket.io.js がブラウザに読み込まれると、io というグローバルオブジェクトが生成されます。
* io.connect メソッドにサーバのアドレスを渡して呼ぶことにより、socket オブジェクトを取得します。
* socket.io は、message や connect、disconnect など、あらかじめ設定されているイベントの他に、emit メソッドを用いてカスタムイベントを発生させることができます。
* クライアントでも、emit でカスタムイベントを発生させることができます。
* クライアントで io.connect('ws://localhost:8080/ ネームスペース '); とし、サーバーで io.of('/ネームスペース') とすれば、ネームスペースが利用できます。
* io.connect を複数回呼び出して、複数の WebSocket ネームスペースを作成しても、複数の WebSocket 接続を生成するわけではありません。socket.io は 1 つの接続を複数の目的のために利用し(もしくは、複数の接続を 1 つに統合し)、ネームスペースのロジックをサーバで処理します。複数の接続を発生させるより、負担の少ないです。
* ネームスペースを使用することにより、複数の種類のタスクを 1 つの socket.io 接続で処理することができます。
* WebSocket の仕様には、サブプロトコルというネームスペースに似た考え方があります。特定の機能・動作を特定のネームスペースに限定することによってコードが読みやすくなります。

## 参考資料、引用資料

* [Nodeクックブック](http://www.oreilly.co.jp/books/9784873116068/)
* [サーバサイドJavaScript Node.js入門](http://ascii.asciimw.jp/books/books/detail/978-4-04-870367-3.shtml)
