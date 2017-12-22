/**
 * Igloo Api Helper class. Provides method to help in connection to Igloo.
 * @author Adrian Espinoza
 *
 */
public class IglooApiHelper {
    /**
    * Parses the Igloo session data into a map.
    * @param response The http response.
    * @return A map with the session information parsed.
    */
    public static Map<String, String> parseIglooSessionInfoToMap(HttpResponse response) {
        Map<string, string> iglooInfo = new Map<string, string>();
        dom.Document doc = response.getBodyDocument();/*as xml document*/
        for(dom.XmlNode node : doc.getRootElement().getChildElements()) {
            if(node.getName()=='response') {
                for(dom.XmlNode node2 : node.getChildElements()) {
                    iglooInfo.put(node2.getName(), node2.getText());
                }
                break;
            }
        }
        return iglooInfo;
    }

    /**
     * Adds especial characters to the url.
     * @param url The url to add especial characters.
     * @return A url with especial character added.
     */
    public static String addSpecialChar(String url) {
        Integer index = url.indexOf('?');
        if (index > -1) {
            if (index != (url.length() - 1)) {
                url = url + '&';
            }
        } else {
            url = url + '?';
        }
        return url;
    }

    /**
     * Encodes the url.
     * @param str The url to encode.
     * @return A url encoded.
     */
    public static String urlEncode(String str) {
        String escaped = str;
        Integer i = -1;
        while ((i = escaped.indexOf('%', i + 1)) > -1) {
            escaped = escaped.substring(0, i + 1) + escaped.substring(i + 1, i + 3).toLowerCase() + escaped.substring(i + 3);
        }
        return escaped;
    }

    /**
     * Attach session information to the url.
     * @param url The url to attach the session information.
     * @param method The request method.
     * @param sessionKey The session key information.
     * @param nonce The nonce key to be used in the url.
     * @param secretKey The secret key information.
     * @return A url with the session attached.
     */
    public static String attachSession(String url, String method, String sessionKey, Long nonce, String secretKey) {
        if (sessionKey != null) {
            String baseUrl = method.toUpperCase() + ':' + url + sessionKey + nonce;
            String signature = IglooSignatureMethod_HMAC_SHA1.buildSignature(baseUrl, secretKey);

            url = IglooApiHelper.addSpecialChar(url);
            String urlResult = url +
                'sessionKey=' + IglooApiHelper.urlEncode(EncodingUtil.urlEncode(sessionKey, 'UTF-8')) +
                '&nonce=' + IglooApiHelper.urlEncode(EncodingUtil.urlEncode(nonce + '', 'UTF-8')) +
                '&signature=' + signature;
            return urlResult;
        }
        return url;
    }

    /**
     * Generates nonce value.
     * @return A nonce value.
     */
    public static Long generateNonce() {
        Long nonce = Crypto.getRandomLong();
        nonce = (nonce < 0) ? (nonce*-1) : nonce;
        return nonce;
    }

    /**
     * Converts unix time stamp to real date as string.
     * @param unixTimestamp The unix time stamp value.
     * @return A real date as string.
     */
    public static string convertUnixTimestampToDateString(string unixTimestamp) {
        unixTimestamp = unixTimestamp.replace('/Date(', '');
        unixTimestamp = unixTimestamp.replace(')/', '');
        unixTimestamp = unixTimestamp.substring(0, unixTimestamp.indexOf('-'));
        DateTime myDate = DateTime.newInstance(Long.valueOf(unixTimestamp));
        return String.valueOfGmt(myDate);
    }

    /**
     * Builds uri based on a key(id).
     * @param baseUrl The base url.
     * @param apimethod The request method.
     * @param replaceKey The key to replace.
     * @param replaceValue The value to replace on the key.
     * @param iglooSessionInfo The Igloo user session information.
     * @return A new uri with the real information.
     */
    public static String makeUriWithKey(String baseUrl, String apimethod, String replaceKey, String replaceValue, Map<string, string> iglooSessionInfo) {
        Long nonce = IglooApiHelper.generateNonce();
        String uri = baseUrl + apimethod.replace('{' + replaceKey + '}', replaceValue);
        uri = IglooApiHelper.attachSession(uri, 'GET', iglooSessionInfo.get('sessionKey'), nonce, iglooSessionInfo.get('secretKey'));
        return uri;
    }
}
