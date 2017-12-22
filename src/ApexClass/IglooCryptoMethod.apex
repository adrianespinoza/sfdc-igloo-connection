/**
 * Igloo Cripto Method class. Provides methods to encrypt and decrypt a string.
 * @author Adrian Espinoza
 *
 */
public class IglooCryptoMethod {
    private static Blob key = Blob.valueOf('1234567890123456');
    private static String algorithmName = 'AES128';
    
    /**
     * Encrypts a text using base 64 encoder.
     * @param clearText The text to encrypt.
     * @return A text encrypted.
     */
    public static String encryptText(String clearText) {        
        Blob cipherText = Crypto.encryptWithManagedIV(algorithmName, key, Blob.valueOf(clearText));
        String encodedCipherText = EncodingUtil.base64Encode(cipherText);
        
      return encodedCipherText;
    }
    
    /**
     * Decrypts a text using base 64 decoder.
     * @param encodedCipherText The text encoded.
     * @return A text decrypted.
     */
    public static String decryptText(String encodedCipherText) {
        Blob encodedEncryptedBlob = EncodingUtil.base64Decode(encodedCipherText);
        Blob decryptedBlob = Crypto.decryptWithManagedIV(algorithmName, key, encodedEncryptedBlob);
        String decryptedClearText = decryptedBlob.toString();
        
        return decryptedClearText;
    }
}