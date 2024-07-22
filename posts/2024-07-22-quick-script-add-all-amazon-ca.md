---
title: Adding all AWS service certificates to your trust store
description: "How to add all the AWS CAs and service certificates to your trust store when working with their services, such as RDS, DocumentDB, Redis, etc."
tags: 
  - aws
  - security
  - ssl
  - tls
  - certificates

---

When working with certain AWS services that require secure connectivity over TCP, you might run into the dreaded *"unable to get local issuer certificate"* error. This is because the service is presenting a certificate signed by an Amazon CA that isn't in your trust store. I've commonly seen this with services such as Redis, DocumentDB, RDS, etc.

With the increased focus on security and expanding services, Amazon have been issuing [a _lot_](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html#UsingWithRDS.SSL.CertificatesDownload) of certificates, and it's a bit of a pain to keep up with them all. It's also not obvious which CA you need when talking to which service, there seem to be a CA for each service in each region with multiple variants. 

There are so many certificates that AWS now issue a [global certificate bundle](https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem) containing all the CAs and certificates together. But if you download and inspect the global bundle, you'll see (at the time of writing) 121 CAs, and they are confusingly named with an RDS prefix. (I can only assume RDS was the first CA they created and all the other departments have just been reusing it).   

The following script will automate downloading and installing the CAs for Linux systems. It will download the global bundle, extract the CAs, copy them to the trust store and update the trust store.  

```bash
certdir=/tmp/aws-certs
mkdir -p "${certdir}"

sudo mkdir -p /usr/local/share/ca-certificates/aws/

curl -sS "https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem" > ${certdir}/global-bundle.pem
awk 'split_after == 1 {n++;split_after=0} /-----END CERTIFICATE-----/ {split_after=1}{print > "aws-ca-" n+1 ".crt"}' < ${certdir}/global-bundle.pem

for cert in aws-ca-*; do
    sudo mv $cert /usr/local/share/ca-certificates/aws/
done

sudo update-ca-certificates
```

With this in place, *most* connectivity to AWS services should work securely.  

But note, not everything looks at the same trust store. For example, Python doesn't look at it by default and you have to [set the `REQUESTS_CA_BUNDLE` environment variable](https://stackoverflow.com/questions/42982143/python-requests-how-to-use-system-ca-certificates-debian-ubuntu). 



### How the script works

It first creates a temporary directory to download the bundle in. It then uses `awk` (which I still don't understand) to split the bundle into individual certificates, with the `.crt` extension as that's what the trust store expects. 

The certificates are then moved to the trust store location and the `update-ca-certificates` command is run to process them.  



