public class IglooSignatureMethod_HMAC_SHA1 {
    public static String getName() {
        return 'hmacSHA1';
    }
 
    public static String buildSignature(String baseUrl, String secret) {    
        Blob sig = Crypto.generateMac(getName(), Blob.valueOf(baseUrl), Blob.valueOf(secret));
        String signature = EncodingUtil.urlEncode(EncodingUtil.base64encode(sig), IglooConstants.ENCODING_SCHEME);        
                
        signature = signature.replace('%2F', '%2f');
        signature = signature.replace('%2B', '%2b');
        signature = signature.replace('%3D', '=');  
        
        System.debug('signature = ' + signature);
        return signature;        
    }
}