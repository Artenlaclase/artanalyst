import urllib.request
import urllib.parse
import json

files = {
    'a6000000-0000-0000-0000-000000000006': 'File:Rembrandt_van_Rijn_-_Self-Portrait_-_Google_Art_Project.jpg',
    'a7000000-0000-0000-0000-000000000007': 'File:El_tres_de_mayo_de_1808_en_Madrid_(2).jpg',
    'a8000000-0000-0000-0000-000000000008': 'File:Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project_-_edited.jpg',
    'a9000000-0000-0000-0000-000000000009': 'File:Edgar_Degas_-_The_Dance_Class_-_1987.47.1_-_Metropolitan_Museum_of_Art.jpg',
    'a1000000-0000-0000-0000-000000000010': 'File:Paul_Cézanne,_1892-95,_Les_joueurs_de_carte_(The_Card_Players),_60_x_73_cm,_oil_on_canvas,_Courtauld_Institute_of_Art,_London.jpg',
    'a1100000-0000-0000-0000-000000000011': 'File:Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg',
    'a1200000-0000-0000-0000-000000000012': 'File:Monet_-_Impression,_Sunrise.jpg',
    'a1300000-0000-0000-0000-000000000013': 'File:Tsunami_by_hokusai_19th_century.jpg',
    'a1400000-0000-0000-0000-000000000014': 'File:Edvard_Munch,_1893,_The_Scream,_oil,_tempera_and_pastel_on_cardboard,_91_x_73_cm,_National_Gallery_of_Norway.jpg',
    'a1500000-0000-0000-0000-000000000015': 'File:The_Kiss_-_Gustav_Klimt_-_Google_Cultural_Institute.jpg',
    'sp16-cassatt-1878': 'File:Mary_Cassatt-Selfportrait.jpg',
    'sp20-schiele-1910': 'File:Schiele_-_Selbstbildnis_mit_Händen_vor_der_Brust.jpg',
}

results = {}

for art_id, file_title in files.items():
    encoded_title = urllib.parse.quote(file_title)
    api_url = f"https://commons.wikimedia.org/w/api.php?action=query&titles={encoded_title}&prop=imageinfo&iiprop=url&iiurlwidth=960&format=json"
    req = urllib.request.Request(api_url, headers={'User-Agent': 'ArtAnalystEducational/1.0 (info@artanalyst.app)'})
    try:
        resp = urllib.request.urlopen(req)
        data = json.loads(resp.read().decode('utf-8'))
        pages = data.get('query', {}).get('pages', {})
        for pid, page in pages.items():
            if 'imageinfo' in page and len(page['imageinfo']) > 0:
                thumb = page['imageinfo'][0].get('thumburl')
                # clean query params like ?utm_source=...
                clean_thumb = thumb.split('?')[0] if thumb else None
                full = page['imageinfo'][0].get('url').split('?')[0]
                results[art_id] = {
                    'title': page.get('title'),
                    'thumbnailUrl': clean_thumb,
                    'imageUrl': clean_thumb or full
                }
                print(f"OK: {art_id} -> {clean_thumb}")
            else:
                print(f"NO IMAGEINFO: {art_id} -> {page}")
    except Exception as e:
        print(f"ERR: {art_id} -> {e}")

with open('scripts/resolved_urls.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, indent=2)

print("\nSaved all to scripts/resolved_urls.json")
