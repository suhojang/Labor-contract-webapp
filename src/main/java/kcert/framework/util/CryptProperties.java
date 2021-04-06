package kcert.framework.util;

import com.kcert.support.Crypto;

public class CryptProperties {
	public static String CRYPT_KEY	= "$KCERT_#N!O@M#U$S%A_@#$^!";
	
	public static String encoded(String plain) throws Exception {
		return encoded(plain, "UTF-8");
	}
	public static String encoded(String plain, String encoding) throws Exception {
		return Crypto.encrypt(plain, CRYPT_KEY, encoding);
	}
	public static String decoded(String plain) throws Exception {
		return new String(Crypto.decryptBytes(plain, CRYPT_KEY, "UTF-8"), "UTF-8");
	}
	public static String decoded(String plain, String encoding) throws Exception {
		return new String(Crypto.decryptBytes(plain, CRYPT_KEY, encoding), encoding);
	}
}
