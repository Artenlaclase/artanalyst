import re
import urllib.request
import urllib.error

with open('packages/app/lib/data/repositories/artwork_repository.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# Find all Artwork instances or image entries
pattern = r"id:\s*['\"]([^'\"]+)['\"].*?title:\s*['\"]([^'\"]+)['\"].*?imageUrl:\s*['\"]([^'\"]+)['\"].*?thumbnailUrl:\s*['\"]([^'\"]+)['\"]"
matches = re.findall(pattern, text, re.DOTALL)

print(f"Found {len(matches)} artworks with images.")

results = []
for artwork_id, title, img_url, thumb_url in matches:
    def test_url(u):
        if u.startswith('assets/'):
            return "LOCAL_ASSET"
        try:
            req = urllib.request.Request(u, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'})
            resp = urllib.request.urlopen(req, timeout=5)
            return resp.status
        except urllib.error.HTTPError as e:
            return f"HTTP_{e.code}"
        except Exception as e:
            return f"ERR_{str(e)[:20]}"

    img_status = test_url(img_url)
    thumb_status = test_url(thumb_url)
    print(f"[{artwork_id}] {title[:30]}: img={img_status}, thumb={thumb_status}")
    results.append((artwork_id, title, img_url, thumb_url, img_status, thumb_status))
