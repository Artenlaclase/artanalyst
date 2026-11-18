import re
import json
import urllib.request
import urllib.error

with open('packages/app/lib/data/repositories/artwork_repository.dart', 'r', encoding='utf-8') as f:
    text = f.read()

idx = text.find('_mockImages = {')
mock_images_text = text[idx:]

pattern = r"'([^']+)':\s*const ArtworkImage\(\s*id:\s*'([^']+)',\s*artworkId:\s*'([^']+)',\s*imageUrl:\s*'([^']+)',\s*thumbnailUrl:\s*'([^']+)'"
entries = re.findall(pattern, mock_images_text)

print(f"Total entries: {len(entries)}", flush=True)

report = {}

for key, img_id, art_id, img_url, thumb_url in entries:
    def check(url):
        if url.startswith('assets/'):
            return 200
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
            res = urllib.request.urlopen(req, timeout=3)
            return res.status
        except urllib.error.HTTPError as e:
            return e.code
        except Exception as e:
            return 999

    s_img = check(img_url)
    s_thumb = check(thumb_url)
    report[art_id] = {
        'img_status': s_img,
        'thumb_status': s_thumb,
        'imageUrl': img_url,
        'thumbnailUrl': thumb_url,
    }
    print(f"{art_id}: img={s_img}, thumb={s_thumb}", flush=True)

with open('scripts/artwork_urls_report.json', 'w', encoding='utf-8') as f:
    json.dump(report, f, indent=2)

print("DONE!", flush=True)
