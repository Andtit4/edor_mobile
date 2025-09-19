// Test des formats d'image supportés
import 'package:image_picker/image_picker.dart';

void main() async {
  final picker = ImagePicker();
  
  print('Test des formats d\'image supportés...');
  
  // Test avec différents formats
  final List<String> testFormats = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  
  for (String format in testFormats) {
    print('\n=== Test format: $format ===');
    
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null) {
        print('✓ Image sélectionnée: ${image.name}');
        print('  - Extension: ${image.name.split('.').last.toLowerCase()}');
        print('  - Path: ${image.path}');
        
        // Lire les bytes pour vérifier la taille
        final bytes = await image.readAsBytes();
        print('  - Taille: ${bytes.length} bytes');
        
        // Vérifier si l'extension correspond au format attendu
        final extension = image.name.toLowerCase().split('.').last;
        if (extension == format) {
          print('  ✓ Format correct');
        } else {
          print('  ⚠ Format différent: $extension au lieu de $format');
        }
      } else {
        print('✗ Aucune image sélectionnée');
      }
    } catch (e) {
      print('✗ Erreur: $e');
    }
  }
  
  print('\n=== Test terminé ===');
}
