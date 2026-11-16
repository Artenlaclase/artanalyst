import os
import urllib.request
import shutil

os.makedirs('assets/images', exist_ok=True)
os.makedirs('packages/app/assets/images', exist_ok=True)

# Wikimedia allowed sizes: 20px, 40px, 60px, 120px, 250px, 330px, 500px, 960px, 1280px, 1920px, 3840px
urls = {
    'van_gogh.jpg': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Van_Gogh_Self-Portrait_with_Straw_Hat_1887-Metropolitan.jpg/500px-Van_Gogh_Self-Portrait_with_Straw_Hat_1887-Metropolitan.jpg',
    'monet.jpg': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Claude_Monet_-_Water_Lilies_-_Google_Art_Project.jpg/500px-Claude_Monet_-_Water_Lilies_-_Google_Art_Project.jpg',
    'vermeer.jpg': 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/1665_Girl_with_a_Pearl_Earring.jpg/500px-1665_Girl_with_a_Pearl_Earring.jpg',
    'friedrich.jpg': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Caspar_David_Friedrich_-_Wanderer_above_the_sea_of_fog.jpg/500px-Caspar_David_Friedrich_-_Wanderer_above_the_sea_of_fog.jpg'
}

headers = {
    'User-Agent': 'ArtAnalyst/1.0 (educational art app; https://github.com/artanalyst)'
}

for name, url in urls.items():
    dest1 = os.path.join('assets', 'images', name)
    dest2 = os.path.join('packages', 'app', 'assets', 'images', name)
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as resp, open(dest1, 'wb') as out_file:
            shutil.copyfileobj(resp, out_file)
        shutil.copyfile(dest1, dest2)
        print(f"SUCCESS: {name} ({os.path.getsize(dest1)} bytes)")
    except Exception as e:
        print(f"ERROR: {name}: {e}")
