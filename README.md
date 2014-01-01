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

## [TAG:NamespaceSocketIOApplication](https://github.com/mori-dev/my-socket-io-sample/tree/NamespaceSocketIOApplication)

* クライアントで io.connect('ws://localhost:8080/ネームスペース '); とし、サーバーで io.of('/ネームスペース') とすれば、ネームスペースが利用できます。
* io.connect を複数回呼び出して、複数の WebSocket ネームスペースを作成しても、複数の WebSocket 接続を生成するわけではありません。socket.io は 1 つの接続を複数の目的のために利用し(もしくは、複数の接続を 1 つに統合し)、ネームスペースのロジックをサーバで処理します。複数の接続を発生させるより、負担の少ないです。
* ネームスペースを使用することにより、複数の種類のタスクを 1 つの socket.io 接続で処理することができます。
* WebSocket の仕様には、サブプロトコルというネームスペースに似た考え方があります。特定の機能・動作を特定のネームスペースに限定することによってコードが読みやすくなります。

* このアプリのサーバ仕様: ブラウザからのリクエストを受けると、レスポンスとしてシリアル化されたデータをブラウザに返す
* このアプリのクライアント仕様: リクエストで指定したメンバーのプロフィールを JSON もしくは XML 形式で受け取って、そのプロフィールをブラウザで表示できるプロフィールビューワ
* URL のルートは 2 つ用意しておきます。1 つはプロフィールの名前リストを返すルート(profiles)、もう 1 つは指定された人のプロフィールを返すルート(/profile)です。
* 'http://localhost:8081/foo' を $.get するなど、Ajax を使っていた箇所を 'ws://localhost:8081/json' で WebSocket で処理するように変更してみる、という内容でした。WebSocket 接続を開始すると connect イベントが発生し、イベントを受け取ったクライアント
は profiles イベントを発行します。profiles イベントを受信したサーバは、プロフィールのキー(名前)のリストをクライアントに送信します。名前のリストを受け取って処理したクライアントは、select 要素が変更されると、カスタム profile イベントを適切なネームスペースに発信します。それぞれのネームスペースのソケットはサーバからの profile イベントを待ち、受信するとそのネームスペース(フォーマット)に応じて処理を行います。
* サーバで fs.readFileSync('index.html'); すれば、同一生成元ポリシーの適用が回避されます。
* foo.coffee を HTML で読み込むには、

```.html
//<script src='http://jashkenas.github.com/coffee-script/extras/coffee-script.js' type='text/javascript'></script>
<script src="coffee-script.js"></script>
```

しておいて、以下のように書きます。

```
<script src="foo.coffee" type="text/coffeescript"></script>
```

* fs.readFileSync 'ここのHTML' で JS や CSS を読み込んでいる場合は、res.writeHead 200, 'text/javascript' などをつけて、その JS や CSS も配信する必要があります。



## [TAG:Counter](https://github.com/mori-dev/my-socket-io-sample/tree/Counter)

### Buffer について

* Buffer は Node が提供する固定長のバイナリデータを扱うためのクラス。
* Buffer はバイナリファイルの読み書きに加え、ストリームのバイナリデータ読み書きの際によく使われており、
  ファイル、ネットワークを流れるバイナリを扱うときなどに利用されます。
* Buffer オブジェクトの作成の際にはサイズを引数に指定する方法とオブジェクトを直接引数に指定する方法があります。

```.javascript
    var buf = new Buffer(16);                   //サイズを指定
    var arrayBuf = new Buffer([1,2,3,4,5,6]);   //オブジェクトを直接引数に指定
    var stringBuf = new Buffer("sample");       //オブジェクトを直接引数に指定
    console.log(buf);       //=> <Buffer 01 00 00 00 00 00 00 00 10 30 65 00 01 00 00 00>
    console.log(arrayBuf);  //=> <Buffer 01 02 03 04 05 06>
    console.log(stringBuf); //=> <Buffer 73 61 6d 70 6c 65>
```

### widget_server.js

* 課題: socket.io でリモートサーバ接続者の数をリアルタイムで更新するウィジェットを作成する。hotnode server.js, hotnode widget-server.js で起動する。
  * index.html:       widget_client.js のトリガー。カウンタの表示。http://localhost:8081/loc/widget.js を読み込んでいる。これは、widget_server.js が配信する、widget_client.js の加工版。
  * widget_client.js: ウィジェット。
  * server.js:        index.html を配信する HTTP サーバ。8082 ポート
  * widget_server.js: ウィジェットサーバ。ウィジェットを通してクライアントが接続するサーバ。8081ポート。

* ws://localhost:8081 は、ウィジェットを通してクライアントが接続するサーバです。
* socket.io-client ライブラリは、widget_client.js をカスタマイズして生成するのに使っています
* widget_client.js をカスタマイズして生成するのに、socket.io-client の builder メソッドを使います
* socket.io-client の builder メソッドの最初の引数は io.transports() で、WebSocket や xhr ポーリングなど、リアルタイム通信を実現するさまざまな手段の配列です。配列の先頭に近いほど優先度が高い手段です。listen メソッドでオプションを設定していないため、メソッドの戻り値はデフォルトの配列です。websocket、htmlfile、xhr-polling、jsonp-polling の順です。
* builder メソッドの 2つ目の引数はコールバック関数です。siojs パラメータに socket.io.js の内容が渡されるので、これをコールバック内で使うことができます。
* io.static.add メソッドで、siojs の内容が widget_client.js の内容とつなげられて、両方の JavaScript コンテンツを含んだ 1 つのファイル(widget.js)が生成されます。これらのスクリプトがお互いに影響しないよう、間にセミコロンをはさみます。繰り返しになりますが、サーバ側で socket.io-client を require して、io.static.add で socket.io.js の内容に追記しています。
* socket.io は、クライアント用 JavaScript ファイルを配信するための HTTP サーバを内部に持っています。HTTP サーバを新たに生成する代わりに、io.static.add メソッドを使って socket.ioの内部 HTTP サーバに新しい URL ルートを設定します。io.static.add の 2 つ目のパラメータにはコールバック関数が渡されます。このコールバック関数は、追加された URL ルートで配信するコンテンツを設定します。
* 最初の引数は物理ファイルを参照しますが、今回は動的にコードを生成するので null を渡します。2 つ目のパラメータは、(widget.js として配信される)siojs と widgetScript のコンテンツをつなげた内容を Buffer に入れて渡しています。これで /widget.js ルートが設定されました。
* io.configure で resource プロパティを変更すると、socket.io が生成する内部 HTTP サーバのルートディレクトリを変更することができます。ここではスクリプトファイルへのアクセスを、デフォルトの http://localhost:8081/socket.io/widget.js ではなく、ウィジェットの名前(LOC)をパスに含んだ http://localhost:8081/loc/widget.js でできるように、resource プロパティの値を設定しています。
* socket.handshake.xdomain は、ハンドシェイクが同じサーバと確立されたかどうかを示します。

### サイトごとの訪問者カウント数を Redis に保存

* totals[origin] に 1 を加える代わりに、Redis の INCR コマンド(totals.incr メソッド)で origin の文字列がキーとなる値をインクリメントします。


## 参考資料、引用資料

* [Nodeクックブック](http://www.oreilly.co.jp/books/9784873116068/)
* [サーバサイドJavaScript Node.js入門](http://ascii.asciimw.jp/books/books/detail/978-4-04-870367-3.shtml)
