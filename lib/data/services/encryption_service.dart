// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Veri Güvenliği Servisi (AES-256 Encryption)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptionService {
  // Anahtarları .env dosyasından çekiyoruz
  static Key get _key {
    final keyStr = dotenv.env['ENCRYPTION_KEY'] ?? 'varsayilan-guvenli-olmayan-anhtr';
    return Key.fromUtf8(keyStr.padRight(32, '0').substring(0, 32));
  }

  static IV get _iv {
    final ivStr = dotenv.env['ENCRYPTION_IV'] ?? 'varsayilan-iv-16';
    return IV.fromUtf8(ivStr.padRight(16, '0').substring(0, 16));
  }

  /// Verilen metni AES-256 ile şifreler.
  static String encryptData(String plainText) {
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Şifrelenmiş metni çözer.
  static String decryptData(String encryptedBase64) {
    final encrypter = Encrypter(AES(_key));
    final decrypted = encrypter.decrypt64(encryptedBase64, iv: _iv);
    return decrypted;
  }

  /// PDF gibi dosyaları şifrelemek için (Uint8List bazlı)
  static List<int> encryptFile(List<int> fileBytes) {
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encryptBytes(fileBytes, iv: _iv);
    return encrypted.bytes;
  }
}

/* 
KULLANIM ÖRNEĞİ:

void savePetition(String petitionBody) {
  // 1. Veriyi şifrele
  String secureContent = EncryptionService.encryptData(petitionBody);
  
  // 2. Şifreli veriyi Firestore'a gönder
  FirebaseFirestore.instance.collection('user_petitions').add({
    'content': secureContent,
    'encrypted': true,
  });
}
*/


