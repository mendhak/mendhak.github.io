---
title: "Custom TLS certificate validation for Android applications"
description: "Workflow for properly validating custom and self signed TLS certificates in Android applications"
tags: 
  - android
  - security
  - tls
opengraph:
  image: /assets/images/android-custom-certificate-validation/002_workflow.png
---

How to properly validate TLS certificates from Android applications - without bypassing or compromising validation.

Several features I've had to develop for [GPSLogger](https://gpslogger.app) allow users to communicate with their own private hosts serving custom SSL/TLS certificates.  The most difficult part about developing for such a workflow is actually finding help and documentation.  Android's [own documentation](https://developer.android.com/training/articles/security-ssl) has some advice, but requires that you already _know_ the certificate in advance.  This doesn't always apply as a user will want to apply their own self signed certificates or use a provider that isn't yet trusted in their version of Android. 

StackOverflow posts on this topic will often given awful answers showing you how to _disable_ validation with a little disclaimer tacked on at the end to the effect of "Here's some bad advice, you should totally not do this in production"; nothing more than a wink and a nod silently saying, "You're going to do this anyway just don't tell anyone".  To Google's credit, they actually scan for applications that do this and send warnings to application owners.  However even so I have seen top rated answers giving advice on how to evade detection rather than actually fix.  

This is extremely dangerous, considering that such code ends up in actual real-world applications susceptible to [man-in-the-middle attacks](https://en.wikipedia.org/wiki/Man-in-the-middle_attack), compromising privacy and security. Here I will detail the method I took to provide a certificate validation workflow in my app. 

## Validation overview

The proper validation workflow consists of a few parts.  First the user must enter the server name or URL they want to connect to, which is being served by their custom certificate.  User taps the validation link, and the app makes a request to the server.  The certificate is fetched and tested to see if it is recognized by the Android OS already.  If it isn't a known certificate, the details of the certificate are presented for the user to look at.  The user can accept the certificate, at which point it's stored in a keystore. 

![Validation workflow](/assets/images/android-custom-certificate-validation/002_workflow.png)

From then on as part of the normal application's running, any requests made are checked against the keystore in order to validate the certificate. 

![Validation workflow](/assets/images/android-custom-certificate-validation/003_workflow.png)



## Sockets and certificates

Depending on the protocol, there are different ways of extracting the certificate.  

For `https`, simply connecting to the socket as a secure `SSLSocket`, and extracting the certificate  using [`SSLSession.getPeerCertificates()`](https://developer.android.com/reference/javax/net/ssl/SSLSession.html#getPeerCertificates()) is sufficient. If the handshake happens successfully, then the certificate is already known and trusted. 

```java

import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import java.security.cert.Certificate;

private void connectToSSLSocket() throws IOException {
  SSLSocketFactory factory = Networks.getSocketFactory(context);
  SSLSocket socket = (SSLSocket) factory.createSocket(host, port);

  socket.setSoTimeout(5000);
  socket.startHandshake();
  SSLSession session = socket.getSession();
  Certificate[] servercerts = session.getPeerCertificates();
}

connectToSSLSocket();
handler.post(new Runnable() {
    @Override
    public void run() {
        //Workflow - the certificate is already valid and trusted by the OS
    }
});

```

### Extracting the certificate

However, if an exception is thrown, then it may be an untrusted certificate, and we must perform extra steps.  The 'unknown' certificate is held in the exception as a cause, strangely, and only if the exception is a `RuntimeException`.  So we must create a wrapper class to hold it once extracted.


```java

public class CertificateValidationException extends RuntimeException {

    private X509Certificate certificate;

    public CertificateValidationException(X509Certificate certificate, String message, Throwable t){
        super(message, t);
        this.certificate = certificate;
    }

    public X509Certificate getCertificate(){
        return certificate;
    }
}

public static CertificateValidationException extractCertificateValidationException(Exception e) {

  if (e == null) { return null ; }

  CertificateValidationException result = null;

  if (e instanceof CertificateValidationException) {
      return (CertificateValidationException)e;
  }
  Throwable cause = e.getCause();
  Throwable previousCause = null;
  while (cause != null && cause != previousCause && !(cause instanceof CertificateValidationException)) {
      previousCause = cause;
      cause = cause.getCause();
  }
  if (cause != null && cause instanceof CertificateValidationException) {
      result = (CertificateValidationException)cause;
  }
  return result;
}

```

So we can catch the exception from the above `connectToSSLSocket()` call.

```java
catch (final Exception e) {

    if (extractCertificateValidationException(e) != null) {
        //Not an untrusted certficiate, some other exception. 
        throw e;
    }

    if(serverType== ServerType.HTTPS){
        handler.post(new Runnable() {
            @Override
            public void run() {
                //Workflow - the certificate was untrusted
                //Show it to the user
            }
        });
        return;
    }
...    
```

As part of the workflow, we'd pass the exception along to the main thread to extract and display to the user. 

### Display the certificate to the user

The user now needs to see the certificate.  The `X509Certificate` has several properties, and the most important ones to display are the Issuer, Fingerprint, Issued Date and Expiry Date. 

```java
sb.append(String.format(msgformat,"Issuer", cve.getCertificate().getIssuerDN().getName()));
sb.append(String.format(msgformat,"Fingerprint", DigestUtils.shaHex(cve.getCertificate().getEncoded())));
sb.append(String.format(msgformat,"Issued on",cve.getCertificate().getNotBefore()));
sb.append(String.format(msgformat,"Expires on",cve.getCertificate().getNotAfter()));
```

It's also important to show all the Subject Alternative Names, using `getSubjectAlternativeNames()`.  There are several different values returned  which is very confusing; the [X509 specification](https://tools.ietf.org/html/rfc2459) helps us here, in that we can see the different types of values returned.  


```
     otherName                       [0]     AnotherName,
     rfc822Name                      [1]     IA5String,
     dNSName                         [2]     IA5String,
     x400Address                     [3]     ORAddress,
     directoryName                   [4]     Name,
     ediPartyName                    [5]     EDIPartyName,
     uniformResourceIdentifier       [6]     IA5String,
     iPAddress                       [7]     OCTET STRING,
     registeredID                    [8]     OBJECT IDENTIFIER }
```

So we are most interested in #2, the `dNSName` which is the more likely subject. And #7, the `iPAddress`, though not as common, but still a possibility. 

```java
 if(cve.getCertificate().getSubjectAlternativeNames() != null 
     && cve.getCertificate().getSubjectAlternativeNames().size() > 0){
    for(List item : cve.getCertificate().getSubjectAlternativeNames()){
        if((int)item.get(0) == 2 || (int)item.get(0) == 7){ //Alt Name type DNS or IP
            sans.append(item.get(1).toString()));
        }
    }
}
```

In my app a user would see a prompt similar to this:

![Custom validation UI](/assets/images/android-custom-certificate-validation/001_validation.gif)

### Saving the certificate to a keystore

When the user accepts, the custom certificate then needs to be saved to a keystore. This can be done in the application's own directory. 

```java

public static void addCertToKnownServersStore(Certificate cert)
            throws  KeyStoreException, NoSuchAlgorithmException, CertificateException, IOException {

    KeyStore knownServersStore = KeyStore.getInstance(KeyStore.getDefaultType());
    File localTrustStoreFile = new File("app.keystore");

    // get the local keystore if it exists, or initialize an empty one
    if (localTrustStoreFile.exists()) {
        InputStream in = new FileInputStream(localTrustStoreFile);
        try {
            knownServersStore.load(in, "somepassword".toCharArray());
        } finally {
            in.close();
        }
    } else {
        knownServersStore.load(null, "somepassword".toCharArray());
    }

    // add the certificate
    knownServersStore.setCertificateEntry(Integer.toString(cert.hashCode()), cert);

    FileOutputStream fos = null;

    try {
        fos = new FileOutputStream(localTrustStoreFile);
        knownServersStore.store(fos, "somepassword".toCharArray());
    }
    catch(Exception e){
        // could not save certificate
    }
    finally {
        fos.close();
    }
}

```

At this point the user has accepted the certificate and it is saved in a keystore.  It can now be used as part of HTTP requests

### Using the certificate from the keystore for HTTP requests

To use the certificate in an HTTP request, we must create a custom Socket Factory. The OKHttp library in turn will check the keystore when validating the certificate.  


```java

public static KeyStore getKnownServersStore()
        throws KeyStoreException, IOException, NoSuchAlgorithmException, CertificateException {

    KeyStore knownServersStore = KeyStore.getInstance(KeyStore.getDefaultType());
    File localTrustStoreFile = new File("app.keystore");

    if (localTrustStoreFile.exists()) {
        InputStream in = new FileInputStream(localTrustStoreFile);
        try {
            mKnownServersStore.load(in, "somepassword".toCharArray());
        } finally {
            in.close();
        }
    } else {
        // next is necessary to initialize an empty KeyStore instance
        mKnownServersStore.load(null, "somepassword".toCharArray());
    }

    return mKnownServersStore;
}


public static SSLSocketFactory getSocketFactory(){
    try {
        SSLContext sslContext = SSLContext.getInstance("TLS");
        LocalX509TrustManager atm = null;

        atm = new LocalX509TrustManager(getKnownServersStore());

        TrustManager[] tms = new TrustManager[] { atm };
        sslContext.init(null, tms, null);
        return sslContext.getSocketFactory();
    } catch (Exception e) {
        // 
    }

    return null;
}


OkHttpClient.Builder okBuilder = new OkHttpClient.Builder();
okBuilder.sslSocketFactory(getSocketFactory());
Request.Builder requestBuilder = new Request.Builder().url("https://example.com");


```

## Handling other protocols and sockets


When connecting over SMTP, a secure handshake requires setting client authentication.  This changes the `connectToSSLSocket` slightly.  

```java
if(serverType == ServerType.SMTP){
    socket.setUseClientMode(true);
    socket.setNeedClientAuth(true);
}
```

Further, it's also necessary to perform an `EHLO` and a `STARTTLS` to elevate the plain socket to a secure socket. 

Similarly, FTP requires an `AUTH SSL` to be elevated.  With these two in mind, the handshake becomes a lengthier.  


```java

try {
    // Trying handshake first in case the socket is SSL/TLS only
    connectToSSLSocket(null);
    postValidationHandler.post(new Runnable() {
        @Override
        public void run() {
            // Workflow finished - this is a known certificate. Nothing to do. 
        }
    });
} catch (final Exception e) {

    if (extractCertificateValidationException(e) != null) {
        throw e;
    }

    // Direct connection failed or no certificate was presented

    if(serverType== ServerType.HTTPS){
        postValidationHandler.post(new Runnable() {
            @Override
            public void run() {
                //Workflow finished - an unknown certificate was found
            }
        });
        return;
    }

    // Nothing yet, so attempt to connect over plain socket first, then elevate.
    Socket plainSocket = new Socket(host, port);
    plainSocket.setSoTimeout(30000);
    BufferedReader reader = new BufferedReader(new InputStreamReader(plainSocket.getInputStream()));
    BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(plainSocket.getOutputStream()));
    String line;

    if (serverType == ServerType.SMTP) {

        writer.write("EHLO localhost\r\n");
        writer.flush();
        line = reader.readLine();
    }

    String command = "", regexToMatch = "";
    if (serverType == ServerType.FTP) {

        command = "AUTH SSL\r\n";
        regexToMatch = "(?:234.*)";

    } else if (serverType == ServerType.SMTP) {

        command = "STARTTLS\r\n";
        regexToMatch = "(?i:220 .* Ready.*)";

    }

    writer.write(command);
    writer.flush();
    while ((line = reader.readLine()) != null) {
        if (line.matches(regexToMatch)) {
            // Elevate socket and attempt handshake.
            connectToSSLSocket(plainSocket);
            postValidationHandler.post(new Runnable() {
                @Override
                public void run() {
                    //Workflow finished - the certificate is known. 
                }
            });
            return;
        }
    }

    //No certificates found.  Giving up.
    postValidationHandler.post(new Runnable() {
        @Override
        public void run() {
            //Workflow finished, give up. 
        }
    });
}

// Additional catch block required outside to handle the elevated socket handshake, capture certificate and present to the user.             

```

## Reference

The full form of this workflow is [here](https://github.com/mendhak/gpslogger/blob/master/gpslogger/src/main/java/com/mendhak/gpslogger/common/network/CertificateValidationWorkflow.java).  The `CertificateValidationWorkflow` is the starting point for the process, and is invoked from an Activity using

    new Thread(new CertificateValidationWorkflow(context, host, port, serverType, postValidationHandler)).start();

