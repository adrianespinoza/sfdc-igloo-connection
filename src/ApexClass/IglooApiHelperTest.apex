@isTest
public class IglooApiHelperTest {
  static testMethod void myTest() {
        Integer newVolume = 25;
        Long nonce = IglooApiHelper.generateNonce();
        System.assertNotEquals(-1, nonce);
        
        String url = 'https://aveh.igloocommunities.com';
        url = IglooApiHelper.addSpecialChar(url);
        System.assertEquals('https://aveh.igloocommunities.com?', url, 'Testing the addition of a special char(?)');
        
        url = url + 'param1=123';
        url = IglooApiHelper.addSpecialChar(url);
        System.assertEquals('https://aveh.igloocommunities.com?param1=123&', url, 'Testing the addition of a special char(&)');
        
        url = IglooApiHelper.urlEncode(url);
        System.assertEquals('https://aveh.igloocommunities.com?param1=123&', url, 'Testing the encoding url');
        
        url = IglooApiHelper.attachSession(url, 'GET', 'ajlkds-adsf45-dsaf-asd-asd-asdfl', nonce, 'hkslkdjf456asd1');
        System.assertNotEquals('https://aveh.igloocommunities.com?param1=123&', url, 'Testing the encoding url');
        
        //'/Date(1434146037653-0400)/'
        String unixTimestamp = '/Date(1434146037653-0400)/';
        String dateResult = IglooApiHelper.convertUnixTimestampToDateString(unixTimestamp);
        System.assertNotEquals('2015-06-12 21:54:27', dateResult, 'Testing the encoding url');
        
        Map<string, string> iglooSessionInfo = new Map<string, string>();
        iglooSessionInfo.put('sessionKey', 'eunklasdu789456');
        iglooSessionInfo.put('secretKey', 'nondskj456asdf');
        String baseUrl = 'https://aveh.igloocommunities.com/test/{paramId}/action?param1=123';
        String resBaseUrl = IglooApiHelper.makeUriWithKey(baseUrl, 'GET', 'paramId', '123456asdf', iglooSessionInfo);
        System.assertNotEquals(baseUrl, resBaseUrl, 'Testing the encoding url');
    }
}