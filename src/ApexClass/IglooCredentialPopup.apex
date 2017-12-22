/**
 * Igloo Credential Popup class. Provide a remote method to update information.
 * @author Adrian Espinoza
 *
 */
public class IglooCredentialPopup {
    public String username {
        get { return username; }
        set { username = value; }
    }
    
    public String password {
        get { return password; }
        set { password = value; }
    }
    /***
     * Remote method that updates Igloo credential in custom setting.
     * @param uname The Igloo user name.
     * @param pass The Igloo password.
     * @return A confirmation message.
     */
    @RemoteAction
    public static String updateCredentials(String uname, String pass) {
        try {
            IglooSettings__c iglooSetttings = [SELECT username__c, password__c FROM IglooSettings__c];
        
            iglooSetttings.username__c = uname;
            iglooSetttings.password__c = IglooCryptoMethod.encryptText(pass);
            
            update iglooSetttings;
            
            return 'OK';
        } catch (Exception e) {
            return e.getMessage();
        }
        
    } 
}