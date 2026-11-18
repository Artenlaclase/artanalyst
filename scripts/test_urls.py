import re
import urllib.request
import urllib.error

with open('packages/app/lib/data/repositories/artwork_repository.dart', 'r', encoding='utf-8') as f:
    text = f.read()

image_urls = re.findall(r'imageUrl:\s*[\'"]([^\'"]+)[\'"]', text)
thumb_urls = re.findall(r'thumbnailUrl:\s*[\'"]([^\'"]+)[\'"]', text)

print(f"Total image_urls: {len(image_urls)}")
print(f"Total thumb_urls: {len(thumb_urls)}")

print("\n--- SAMPLE IMAGE URLS ---")
for i, u in enumerate(image_urls[:20]):
    print(f"{i+1}: {u}")
