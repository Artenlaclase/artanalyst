import re
import urllib.request
import urllib.error

with open('packages/app/lib/data/repositories/artwork_repository.dart', 'r', encoding='utf-8') as f:
    text = f.read()

idx = text.find('_mockImages = {')
mock_images_text = text[idx:]

pattern = r"'([^']+)':\s*const ArtworkImage\(\s*id:\s*'([^']+)',\s*artworkId:\s*'([^']+)',\s*imageUrl:\s*'([^']+)',\s*thumbnailUrl:\s*'([^']+)'"
entries = re.findall(pattern, mock_images_text)

print(f"Found {len(entries)} artwork image entries in _mockImages.\n")

failed = []
success = []

for key, img_id, art_id, img_url, thumb_url in entries:
    def test_url(u):
        if u.startswith('assets/'):
            return "LOCAL"
        try:
            req = urllib.request.Request(u, headers={'User-Agent': 'ArtAnalystEducational/1.0 (info@artanalyst.app)'})
            resp = urllib.request.urlopen(req, timeout=5)
            return str(resp.status)
        except urllib.error.HTTPError as e:
            return f"HTTP_{e.code}"
        except Exception as e:
            return f"ERR_{type(e).__name__}"

    i_stat = test_url(img_url)
    t_stat = test_url(thumb_url)
    
    status_str = f"img={i_stat}, thumb={t_stat}"
    print(f"[{art_id}] {status_str}")
    if i_stat not in ("200", "LOCAL") or t_stat not in ("200", "LOCAL"):
        failed.append((art_id, img_url, thumb_url, i_stat, t_stat))
    else:
        success.append((art_id, img_url, thumb_url))

print(f"\n--- SUMMARY: {len(success)} OK, {len(failed)} FAILED ---")
for f_art_id, f_img, f_thumb, f_istat, f_tstat in failed:
    print(f"\nFAILED ARTWORK: {f_art_id}")
    print(f"  img ({f_istat}): {f_img}")
    print(f"  thumb ({f_tstat}): {f_thumb}")
