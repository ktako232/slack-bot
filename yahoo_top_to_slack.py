import os, json, urllib.request, urllib.parse
import xml.etree.ElementTree as ET
from dotenv import load_dotenv

load_dotenv()
WEBHOOK = os.environ["SLACK_WEBHOOK_URL"]

RSS_URL = "https://news.yahoo.co.jp/rss/topics/top-picks.xml"

with urllib.request.urlopen(RSS_URL, timeout=10) as res:
    xml_bytes = res.read()

root = ET.fromstring(xml_bytes)
items = root.findall(".//item")[:5]

lines = []
for it in items:
    title = (it.findtext("title") or "").strip()
    link  = (it.findtext("link") or "").strip()

    lines.append(f"• <{link}|{title}>")

text = ":newspaper: *Yahoo! JAPAN トップ（最新5件）*\n" + "\n".join(lines)

payload = {"text": text}
req = urllib.request.Request(
    WEBHOOK,
    data=json.dumps(payload).encode(),
    headers={"Content-Type": "application/json"}
)
with urllib.request.urlopen(req, timeout=10) as r:
    r.read()
