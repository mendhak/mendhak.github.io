---
title: "Using Gradle to PGP sign and checksum files"
description: "Using Gradle to automatically and securely PGP sign files and creat checksum files"
categories: 
  - gradle
  - android
  - pgp
tags: 
  - gradle
  - android
  - pgp

---

When creating software for distribution to end users, it's a good idea to enable checking its integrity and trustworthiness.  

A checksum file allows a user to download the file and ensure that it wasn't corrupted during download or replaced on the server by an attacker.  A signature file allows a user to verify that it actually came from the developer.  

## Creating a checksum file

A simple way to do this is to use the `ant` [checksum](https://ant.apache.org/manual/Tasks/checksum.html) integration that [comes with Gradle](https://docs.gradle.org/current/userguide/ant.html). There are several algorithms to choose from including MD5, SHA-1, SHA-256 and SHA-512.  This will create a `myFile.SHA256` file, where `myFile` is the thing you want to distribute to users, such as an `.exe` or `.apk`.   

```groovy
ant.checksum(file: 'myFile', fileext: '.SHA256', algorithm: "SHA-256", pattern: "{0} {1}")
```

## Creating a signed file

Gradle comes with a [signing plugin](https://docs.gradle.org/current/userguide/signing_plugin.html).  First apply the plugin in your `build.gradle`,

```groovy
apply plugin: 'signing'
```

You'll need to provide the signing plugin with the PGP key ID and passphrase to use.  There are several ways to do this, one way is to create file at `~/.gradle/gradle.properties` 

```ini
signing.gnupg.keyName=ABCD1234
signing.gnupg.passphrase=hunter2
```

The advantage of this gradle.properties file is that it sits outside source control, no accidental commits, and its properties are read by Gradle when a task is run.  

Finally you can sign the file, this will create a `myFile.asc` file with a PGP signature in it. 

```groovy
signing {
            useGpgCmd()
            sign file('myFile')
        }
```

`useGpgCmd()` will use the GPG executable on your system, this should already be present on Linux systems.  With Windows you'd need to install GPG, it comes with with [Git for Windows](https://git-scm.com). 

You will find [other instructions](https://docs.gradle.org/current/userguide/signing_plugin.html#sec:signatory_credentials) where a `key`, `password` and `secretKeyRingFile` file are required.  However, since GPG 2.1 [there is no secring file](https://gnupg.org/faq/whats-new-in-2.1.html#nosecring), so it is better to `useGpgCmd()` instead.  
{: .notice--warning}


### All together in a Gradle task

In this example, I'm creating an Android APK, its checksum and signature files in a task.

```groovy
task createVerificationFiles(group:'build') {
    def finalApkName = "gpslogger-"+android.defaultConfig.versionName+".apk"

    copy{
        from "build/outputs/apk/release/gpslogger-release.apk"
        into "./"

        // copy and rename file
        rename { String fileName ->
            fileName.replace("gpslogger-release.apk", finalApkName)
        }
    }

    if(file(finalApkName).isFile()){
        //PGP Sign
        signing {
            useGpgCmd()
            sign file(finalApkName)
        }

        //SHA256 Checksum
        ant.checksum(file: finalApkName, fileext: '.SHA256', algorithm: "SHA-256", pattern: "{0} {1}")
    }
}
```



## Verifying your downloads

Help your users out by sharing instructions on how to verify your downloads.  

### Verify the checksum


To verify the checksum file, you can use `sha256sum`, if you used SHA-512, you can use `sha512sum` on Linux. 

```bash
sha256sum -c ~/Downloads/myFile.SHA256
```


### Verify the signature

Users will first need to import your public PGP key.  Easy ways are via [keybase](https://keybase.io/mendhak) or a receive key command

```bash
gpg --recv-key 6989CF77490369CFFDCBCD8995E7D75C76CBE9A9
```

You can then verify the `.asc`

```bash
gpg --verify ~/Downloads/myFile.asc
```

