# Slack Hello Bot (Incoming Webhook)

このリポジトリは、Slackの **Incoming Webhook** を利用してチャンネルにメッセージを送信する最小サンプルです。  
Python 標準ライブラリのみで動作します。

## 事前準備（Slack 側）
1. Slack の管理画面から [Incoming Webhooks](https://api.slack.com/messaging/webhooks) を有効化する。
2. 「アプリを作成」し、送りたいチャンネルを選択して **Webhook URL** を取得する。  
   - 例: `https://hooks.slack.com/services/XXXX/XXXX/XXXXXXXX`

---

## 実行方法
1. ソースコードをコピーして `send_message.py` として保存します。
2. 取得した Webhook URL を `url` 変数に貼り付けます。
   ```python
   url = "https://hooks.slack.com/services/XXXX/XXXX/XXXXXXXX"
