import json, urllib.request
url = "https://hooks.slack.com/services/XXXX/XXXX/XXXXXXXX"
data = {"text": "こんにちは. お元気ですか?"}
req = urllib.request.Request(url, data=json.dumps(data).encode(), headers={"Content-Type":"application/json"})
urllib.request.urlopen(req)
