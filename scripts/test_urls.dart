import 'dart:io';

void main() async {
  final client = HttpClient()..badCertificateCallback = ((cert, host, port) => true);
  final urls = [
    'https://upload.wikimedia.org/wikipedia/commons/0/0f/1665_Girl_with_a_Pearl_Earring.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/b/b2/Vincent_van_Gogh_-_Self-Portrait_with_Straw_Hat_-_Google_Art_Project.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/d/d4/Vincent_van_Gogh_-_Self-portrait_with_straw_hat%2C_1887.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/a/a4/Claude_Monet_-_Water_Lilies_-_Google_Art_Project.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/b/b9/Caspar_David_Friedrich_-_Wanderer_above_the_sea_of_fog.jpg'
  ];

  for (final u in urls) {
    try {
      final req = await client.getUrl(Uri.parse(u));
      req.headers.set('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
      req.headers.set('Accept', 'image/webp,image/apng,image/*,*/*;q=0.8');
      final res = await req.close();
      print('$u -> ${res.statusCode}');
    } catch(e) {
      print('$u -> error: $e');
    }
  }
  exit(0);
}
