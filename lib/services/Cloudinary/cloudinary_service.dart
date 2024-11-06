import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  final String cloudName = 'nguyenlequan'; // Replace with your Cloudinary cloud name
  final String apiKey = 'QIJHOKJS1spESkwBGo4EpQPcavH'; // Replace with your Cloudinary API key
  final String apiSecret = 'WLymPCVbMg3csbESNxeHJiSr540MK0EXldELkCE2zjPaan8QrTAOxyiN+HXNfQOYP7MKCVsF8mbUruagRY0qpA=='; // Replace with your Cloudinary API secret

  Future<String> uploadImage(XFile image) async {
    final File file = File(image.path);
    
    try {
      final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
      final Map<String, String> headers = {
        'X-Requested-With': 'XMLHttpRequest',
      };

      final Map<String, String> body = {
        'file': await _getBase64Image(file),
        'upload_preset': 'flutter_upload', // Replace with your upload preset
      };

      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['secure_url']; // Return the secure URL of the uploaded image
      } else {
        print('Error uploading image: ${response.reasonPhrase}');
        return '';
      }
    } catch (error) {
      print("Error uploading image: $error");
      return '';
    }
  }

  Future<String> _getBase64Image(File file) async {
    final bytes = await file.readAsBytes();
    return 'data:${file.path.split('.').last};base64,' + base64Encode(bytes);
  }
}
