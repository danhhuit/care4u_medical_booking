import 'dart:io';
import 'package:image/image.dart';

void main() {
  final file = File('assests/images/logo.png');
  final bytes = file.readAsBytesSync();
  final img = decodePng(bytes);

  if (img == null) {
    print('Failed to decode image');
    return;
  }

  // Iterate over all pixels
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      final pixel = img.getPixel(x, y);
      
      int r = pixel.r as int;
      int g = pixel.g as int;
      int b = pixel.b as int;
      
      // The background of logo.png looks white. We threshold at 200 to clear light grey artifacts.
      if (r > 200 && g > 200 && b > 200) {
        // keep it as transparent
        pixel.setRgba(r, g, b, 0);
      }
    }
  }

  // Save to a NEW file to absolutely prevent any browser caching issues!
  File('assests/images/logo_transparent.png').writeAsBytesSync(encodePng(img));
  print('Saved to logo_transparent.png successfully');
}
