import os
import json, urllib.parse, urllib.request
from dotenv import load_dotenv
load_dotenv()

WEBHOOK = os.environ["SLACK_WEBHOOK_URL"]

query = "東京駅 ラーメン"
maps_url = f"https://www.google.com/maps/search/?api=1&query={urllib.parse.quote(query)}"

payload = {
    "text": f"Googleマップ検索: {query}\n{maps_url}"
}

req = urllib.request.Request(
    WEBHOOK,
    data=json.dumps(payload).encode(),
    headers={"Content-Type":"application/json"}
)
urllib.request.urlopen(req)
