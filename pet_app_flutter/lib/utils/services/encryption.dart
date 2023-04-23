import 'dart:convert';
import 'dart:typed_data';

import 'package:webcrypto/webcrypto.dart';

class Encryption {
  Map<String, dynamic> publicKeyJwk;
  Map<String, dynamic> privateKeyJwk;
  final Uint8List iv = Uint8List.fromList('Initialization Vector'.codeUnits);

  Future<void> generateKeys() async {
    KeyPair<EcdhPrivateKey, EcdhPublicKey> keyPair =
        await EcdhPrivateKey.generateKey(EllipticCurve.p256);
    publicKeyJwk = await keyPair.publicKey.exportJsonWebKey();
    privateKeyJwk = await keyPair.privateKey.exportJsonWebKey();
  }

  Future<Uint8List> deriveKey(
    Map<String, dynamic> publicKeyJwk,
    Map<String, dynamic> privateKeyJwk,
  ) async {
    EcdhPublicKey ecdhPublicKey =
        await EcdhPublicKey.importJsonWebKey(publicKeyJwk, EllipticCurve.p256);

    EcdhPrivateKey ecdhPrivateKey = await EcdhPrivateKey.importJsonWebKey(
      privateKeyJwk,
      EllipticCurve.p256,
    );

    Uint8List derivedBits = await ecdhPrivateKey.deriveBits(256, ecdhPublicKey);
    return derivedBits;
  }

  Future<String> encrypt(String message, Uint8List derivedBits) async {
    AesGcmSecretKey aesGcmSecretKey =
        await AesGcmSecretKey.importRawKey(derivedBits);

    List<int> list = message.codeUnits;
    Uint8List data = Uint8List.fromList(list);

    Uint8List encryptedBytes = await aesGcmSecretKey.encryptBytes(data, iv);

    String encryptedString = String.fromCharCodes(encryptedBytes);
    print('encryptedString $encryptedString');
    return encryptedString;
  }

  Future<String> decrypt(String encryptedMessage, Uint8List derivedBits) async {
    AesGcmSecretKey aesGcmSecretKey =
        await AesGcmSecretKey.importRawKey(derivedBits);

    List<int> message = Uint8List.fromList(encryptedMessage.codeUnits);

    Uint8List decryptdBytes = await aesGcmSecretKey.decryptBytes(message, iv);

    String decryptdString = String.fromCharCodes(decryptdBytes);
    print('decryptdString $decryptdString');
    return decryptdString;
  }
}