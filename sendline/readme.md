IFTTTと連携して、特定のログが出現した時にLINEにメッセージを送って通知する

TELLが来た時は検索条件に依らず自動的に通知する

IFTTT
https://ifttt.com/explore

1.アカウントを取得
2.右上のcreate
3.if thisのadd
4.検索窓からwebhooksを探す
5.Receive a Web requestを選択
6.イベントネームはLINE_FFXI
7.Then Thatのadd
8.検索窓からLINEを探す
9.Send Messageを選択
10.LINEアカウントの連携になるので許可する
11.Recipientは1:1でもいいし、複数のLINEアカウントから監視したいならそれらのアカウントでLINEグループを作る。その際はLINE Notifyもグループに加える
12.Messageは{{Value1}}のみとする
13.タイトルは適当で良い
14.右上のプロフィールアイコンからMy servicesへ
15.webhooksのDocumentationを見るとKeyが載っているので、スクリプト内のifttt_key =にコピペ
16.スクリプト内にマッチング文字列を入力


問題点
ちょいちょい文字化けする
まぁ大意が伝わればいいかなと言うことで放置

