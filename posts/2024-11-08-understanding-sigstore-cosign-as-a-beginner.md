---
title: Modern artifact signing with Cosign, what works and what hurts
description: Trying to understand cosign as a beginner, figuring out where it fits and where it's a bit rough
tags:
  - supply chain
  - cosign
  - sigstore
  - pgp
  - security
---

I've been seeing some buzz around Sigstore recently, it's a project that aims to improve software supply chain security by making signing and checking easier. It has seen ongoing work in the [Python](https://blog.sigstore.dev/announcing-the-1-0-release-of-sigstore-python-4f5d718b468d/) and [Maven](https://central.sonatype.org/news/20220302_firstlook/) ecosystems, as well as [npm](https://docs.npmjs.com/generating-provenance-statements) and [Github Actions](https://docs.github.com/en/actions/security-for-github-actions/using-artifact-attestations/using-artifact-attestations-to-establish-provenance-for-builds), which is pretty significant.   

Sigstore is a project that aims to improve supply chain security, and one of its prominent projects is Cosign used for signing and verification. 

It removes much of the risk and maintenance around signing and verification. Although PGP exists, and has been used in this space for a long time, many developers find it difficult to work with. Sigstore's tools are an attractive alternative because they make it possible to work without keys and automates away as much as possible. I thought it would be worth getting a closer look at signing artifacts using cosign, with my newcomer's lens on. 

## Newbie's view of how it works

Sigstore's main selling point is its "keyless" signing capability — more precisely, its ability to work with temporary key pairs that users don't need to manage. 

A typical signing workflow would look something like this: 

* developer initiates signing (using Cosign)
* browser opens for authentication
* developer logs in with their OpenID Connect (OIDC) provider (GitHub, Google, Microsoft)
* once verified, Sigstore's certificate authority (Fulcio) issues a short-lived certificate
* cosign signs the artifact
* signature and the certificate are recorded in Sigstore's tamper proof log (Rekor)

On the other side, an end user can verify the signed artifact against the transparency logs. 

## Signing and verifying with `cosign`

The main tool in this song and dance is `cosign` which I spent most of my time interacting with. [Installing it](https://docs.sigstore.dev/cosign/system_config/installation/#with-the-cosign-binary-or-rpmdpkg-package) was straightforward, but I was surprised to see no official package for Ubuntu. Considering that most CI tooling and pipelines run on Ubuntu, I would have expected there be an official repository to keep the tools up to date. After all, one of the core mitigations of supply chain risks is to keep everything up to date. I did raise a Github issue and hopefully there's a favourable outcome from it. 

Signing a text file was easy, using the sign-blob subcommand. 

```bash
cosign sign-blob test.txt --bundle test.txt.cosign.bundle
```

This opened up a browser to initiate the OAuth workflow, where I logged in with my Github account.

![Sigstore sign in](/assets/images/understanding-sigstore-cosign/001.png)

Once signed in, the process continued in the terminal, where it requested the short lived certificate, signed the artifact, recorded the transaction, and output the bundle file. 

This bundle file is important for the verification process. To verify, an end user would use the verify-blob subcommand with the bundle file. A slight pain point is they would also need to know the email address and the OIDC issuer that was used. For Github this was:  

```bash
$ cosign verify-blob test.txt --bundle test.txt.cosign.bundle --certificate-identity=username@example.com --certificate-oidc-issuer=https://github.com/login/oauth

Verified OK
```

### But where's the log?

It isn't obvious where the transparency ledger is or where the record of the transaction goes. It took a lot of digging to find what was a simple answer. When sign-blob finishes its work, it outputs a `logIndex` number. That value can be plugged into a URL like so:

    https://search.sigstore.dev/?logIndex=140392200



### My first in-the-wild verification didn't work

I had noticed that Python releases now came with Sigstore bundle links, so I thought to try and verify them. Sadly, in the [Python 3.14 release](https://www.python.org/downloads/release/python-3140a1/), although there were Sigstore bundles provided, I wasn't able to verify them with cosign. 

I downloaded the main file and the Sigstore bundle, and looked at [their Sigstore documentation](https://www.python.org/downloads/metadata/sigstore/) to construct the command. Although their examples use a python pip module for Sigstore, I wanted to use the same cosign tool that I'd supposedly be using everywhere else. I thought it was a reasonable expectation to be able to substitute one for the other.    

But I got an error:  

```bash
$ wget https://www.python.org/ftp/python/3.14.0/Python-3.14.0a1.tgz
$ wget https://www.python.org/ftp/python/3.14.0/Python-3.14.0a1.tgz.sigstore
$ cosign verify-blob Python-3.14.0a1.tgz --bundle Python-3.14.0a1.tgz.sigstore --cert-identity hugo@python.org --cert-oidc-issuer https://accounts.google.com

... bundle does not contain cert for verification, please provide public key
```

Inspecting the bundle and following the [log index URL](https://search.sigstore.dev/?logIndex=140392186), I noticed that the OIDC issuer is actually Github, not Google as the Python documentation specified.  

![Python docs vs Rekor log](/assets/images/understanding-sigstore-cosign/002.png)


I raised an issue and they helpfully fixed the issue. Anyway, substituting for Github still did not work though. 

```bash
$ cosign verify-blob Python-3.14.0a1.tgz --bundle Python-3.14.0a1.tgz.sigstore --cert-identity hugo@python.org --cert-oidc-issuer https://github.com/login/oauth

... bundle does not contain cert for verification, please provide public key
```

Finally, I gave in, using the python Sigstore module worked. But why?

```bash
$ python3 -m sigstore verify identity --bundle Python-3.14.0a1.tgz.sigstore --cert-identity hugo@python.org --cert-oidc-issuer https://github.com/login/oauth Python-3.14.0a1.tgz

OK: Python-3.14.0a1.tgz
```

I could not figure out what was different about this, or how I would have provided the public key that the error message asked for, but having to use yet _another_ tool to do the verification was not ideal. 

I finally got a helpful answer from the Sigstore discussion forum, I was missing a `--new-bundle-format` flag. That is, this worked:

```bash
$ cosign verify-blob Python-3.14.0a1.tgz --bundle Python-3.14.0a1.tgz.sigstore --cert-identity hugo@python.org --cert-oidc-issuer https://github.com/login/oauth --new-bundle-format
Verified OK
```

### Verifying Github and npm attestations without their own CLIs

I also learned that [both Github Actions as well as npm](https://blog.sigstore.dev/cosign-verify-bundles/) have integrated cosign workflows, which they call attestations. That is, it should now be possible to verify npm tarballs as well as Github Artifacts, if the author has chosen to make use of attestation workflows. 

It did take a bit of trial and error to figure out where to get the bundle from, which even the blog author attests (ha) to.  

npm has documented instructions on [how to push attestations up](https://docs.npmjs.com/generating-provenance-statements), but the actual verification is hidden away behind an `npm audit signatures` command. They also embed their cosign bundle inside a wrapper JSON. The equivalent cosign way would be:

```bash
$ curl https://registry.npmjs.org/semver/-/semver-7.6.3.tgz > semver-7.6.3.tgz
$ curl https://registry.npmjs.org/-/npm/v1/attestations/semver@7.6.3 | jq '.attestations[]|select(.predicateType=="https://slsa.dev/provenance/v1").bundle' > npm-provenance.sigstore.json
$ cosign verify-blob --bundle npm-provenance.sigstore.json --new-bundle-format --certificate-oidc-issuer="https://token.actions.githubusercontent.com" --certificate-identity="https://github.com/npm/node-semver/.github/workflows/release-integration.yml@refs/heads/main" semver-7.6.3.tgz
Verified OK
```

Github hides theirs behind a `gh attestation verify` command in their own CLI, which I am not interested in, I'd like to see the actual pieces involved. For Github Actions, if the author makes use of the [attest build provenance action](https://github.com/actions/attest-build-provenance), the attestation is made visible at a special dedicated URL that contains attestation information, I thought that was quite neat. 

[This example](https://github.com/cli/cli/attestations/2733309) is from the gh CLI itself, though there is no 'direct' link between the artifact and the attestation page; there is a link from the Github Action build where the artifact was created, but those artifact links are often expired.

{% gallery "Artifact and attestation" %}
![The artifact in releases](/assets/images/understanding-sigstore-cosign/006.png)
![The attestation details](/assets/images/understanding-sigstore-cosign/005.png)  
{% endgallery %}

It took a bit of figuring out but the verification was slightly easier than npm. I had to download the JSON from the attestation page, and also use the new bundle format flag. The certificate identity was the Build Signer URI, and the issuer was the Issuer field. 

```bash
$ curl https://github.com/cli/cli/attestations/2733309/download > gh_2.60.1_linux_386.deb.cosign.bundle
$ curl -L https://github.com/cli/cli/releases/download/v2.60.1/gh_2.60.1_linux_386.deb > gh_2.60.1_linux_386.deb 
$ cosign verify-blob gh_2.60.1_linux_386.deb --bundle cli-cli-attestation-2733309.sigstore.json --cert-identity https://github.com/cli/cli/.github/workflows/deployment.yml@refs/heads/trunk  --cert-oidc-issuer https://token.actions.githubusercontent.com --new-bundle-format
Verified OK
```


### If verifying is hard, nobody will verify

A recurring speed bump in all my verification attempts was to keep trying to figure out how to supply the additional parameters to verify. The need for specifying a certificate identity and certificate OIDC issuer was introduced specifically [to mitigate a security risk](https://github.com/sigstore/cosign/issues/2056), which makes sense.

But, if figuring out the required values for identity and issuer is made difficult, people will [resort to workarounds](https://stackoverflow.com/questions/78073656/how-do-i-verify-container-image-signatures-using-sigstore-cosign-v2). There exist regex versions of the identity and issuer flags in the verify subcommand, which can be used like so:

```bash
cosign verify-blob test.txt --bundle test.txt .cosign.bundle --certificate-identity-regexp '.*'  --certificate-oidc-issuer-regexp='.*'
```

This reminds me of StackOverflow answers regarding certificate validation errors, where the top voted answer is often how to _disable_ validation, with a wink-wink disclaimer saying not to use it in production.  

Further, I don't think it's a good idea that the verification for various ecosystems is hidden behind their own CLIs (ie, npm, gh and python). I would feel better with the consistency of being able to use the cosign CLI across ecosystems, but I wonder if my outlook will change in the future. 

### Keyless is not private

When using the keyless workflow, the email address from the identity provider (Github, Google, Microsoft) is  used as the identifier for the certificate that Sigstore's certificate authority (Fulcio) uses. That email address also ends up in the transparency logs since it's in the certificate, and the [Python release log](https://search.sigstore.dev/?logIndex=140392186) from above does show an email address. It would have been nice, at least with Github, if the masked email they provide could be used (`@users.noreply.github.com`). 

In general, I did not feel comfortable using this workflow. Indeed this privacy aspect is a [known issue](https://blog.sigstore.dev/privacy-in-sigstore-57cac15af0d0/), but there aren't any convenient solutions. A promising one looks to be Pairwise Pseudonymous Identifiers, but it's not widely supported by OIDC providers yet. A simple alternative is to use _keyed_ workflow, where you generate a private and public key yourself, and use that with cosign to sign the artifacts. However this isn't too far off from just using `openssl` to sign artifacts.  


## Automated signing is where `cosign` shines

With CI/CD systems, there is no browser, so you can't really log in as yourself. Instead, cosign recognizes various well known CI systems and uses OIDC tokens that those providers can generate. 

With Github Actions, there's an action to install Cosign. Running `cosign sign-blob` uses the Github Actions `id-token` permission to request a JWT when it communicates with the certificate authority. 

```yml
permissions:
  id-token: write 

# ... jobs/build/steps/ ...

- name: Install Cosign
    uses: sigstore/cosign-installer@v3.7.0
- name: Sign a file
    run: |
    cosign sign-blob --yes README.md --bundle README.md.cosign.bundle
```

Given the bundle output from that action, verifying the blob required knowing the URL to the 'identity', with the Github Actions tokens issuer. The identity in this case turned out to be a Github Actions file reference:  

```bash
cosign verify-blob README.md  --bundle README.md.cosign.bundle --certificate-identity=https://github.com/mendhak/cosign-experiment/.github/workflows/action.yml@refs/heads/main --certificate-oidc-issuer=https://token.actions.githubusercontent.com
```

Although at this point `cosign` is starting to look like a lot of hidden away \*hand-wavy\* magic, I can see what they're trying to get at by trying to be as plug and play as possible with common workflows.  

The good news is that this workflow _is_ private, because the identifier is the Github Action URL. Here is the [Rekor log](https://search.sigstore.dev/?logIndex=146080292) for the above example. 

I believe this is where cosign shines, despite the awkward verification step. 


## Signing Docker images

Signing Docker images is how Sigstore originally started out, before it expanded to other areas such as blobs and git commits.

Signing Docker images is very similar to blobs. 

```yml
{% raw %}
- name: Sign the images with GitHub OIDC Token
  env:
    DIGEST: ${{ steps.build-and-push.outputs.digest }}
    TAGS: ${{ steps.docker_meta.outputs.tags }}
  run: |
        images=""
        for tag in ${TAGS}; do
        images+="${tag}@${DIGEST} "
        done
        cosign sign --yes ${images}
{% endraw %}
```

A few differences though. It is discouraged to sign tags (such as `:1.0.0` or `:latest`), and there is a plan to remove that ability in the future. It is better to sign digests instead, however that does lead to quite a bit of clutter in many Docker registries currently. In this screenshot below, the tag that I've just worked on sits alongside multiple digest tags each one of which appears to be a signed layer.  

![Clutter](/assets/images/understanding-sigstore-cosign/003.png)

Unfortunately that put me off for now as it means I'm not able to control which tags are available for download, and feels like too much of a workaround. I hope in the future registries are able to work with this format a little more directly. 


## Signing git commits

Sigstore does talk about the ability to sign git commits, but it required yet another tool to install, called gitsign. Since git already comes with the ability to sign commits, I didn't bother exploring it, I'd much rather be using [SSH keys to sign commits](/posts/2024-02-15-keepassxc-sign-git-commit-with-ssh.md). 

## Signing with local keys

Everything so far has been about keyless signing, but it is possible to [sign with regular keys](https://docs.sigstore.dev/cosign/key_management/signing_with_self-managed_keys/) too. 

This is made possible by generating a key pair, using it to sign locally, and then publish to the transparency log. 

```bash
cosign generate-key-pair  
cosign sign-blob --bundle local.bundle --key cosign.key README.md  
```

The transparency log record is [much simpler](https://search.sigstore.dev/?logIndex=146138179). 

![Signed with local key pair](/assets/images/understanding-sigstore-cosign/004.png)

Verifying just requires the public key, no issuer or identity.

```bash
cosign verify-blob README.md --bundle local.bundle  --key cosign.pub
```

The documentation also mentions that it is possible to [import keys](https://docs.sigstore.dev/cosign/key_management/import-keypair/), but it didn't work with my ed25519 keys. I had been hoping that it could lead to a fancy, ego stroking verification method that let me point at my Github hosted keys URL.  

```bash
cosign verify-blob README.md --bundle local.bundle  --key https://github.com/mendhak.keys
```


## My thoughts

Sigstore's suite of tools does a lot of things. Its overall goal is to improve the software supply chain. I think at least in terms of CI/CD, it is something worth looking at, for blobs at least. It does feel like a good approach to signing. Short lived certificates are generated, signs the thing it needs to sign, and records the activity in a transparency log. 

It still feels quite rough in many areas; some of the documentation feels like it's written for someone _already_ familiar with Sigstore (and it took me a lot of searching to find answers to the questions I had), and there are a lot of things hidden or abstracted away, but this is also meant to be its strength. To that end, I did find this useful page talking about how to do [Cosign, the manual way](https://edu.chainguard.dev/open-source/sigstore/cosign/cosign-manual-way/).

Considering that it's a supply chain security tool, it ought to take its distribution channels more seriously; currently it's only providing .deb for Debian and Ubuntu, but one of the fundamental tenets in supply chain security is staying up to date, so it's important to participate in OS native package managers and their supply chain security. 

The tooling and by extensions, ecosystem, feels fragmented. I didn't like that the 'usual' cosign command couldn't be used for Python Sigstore files without having to ask or hunting around and guessing (similar for Github and npm attestations), and each ecosystem seemingly wants to hide away details in their own tooling. At the same time the various Sigstore features would have me contend with rekor, fulcio and gitsign, each of which has its own packages, or lack of packages. It would be much neater if there were a single `sigstore` command which contained all of the subcommands necessary. 

Finally, metadata discoverability feels poor. The ability to verify a bundle requires additional information which is difficult to discover and in some cases, even discovering that information isn't enough. 

There are other similar efforts happening, one of which is called [OpenPubkey](https://github.com/openpubkey/openpubkey). OpenPubkey makes use of JWTs signed by identity providers (Github, Google, Microsoft) and adds key information into the `nonce` field. Aside from making British people giggle, the advantage here is that there is no central infrastructure needed, everything is in the token, but it feels like a hack, and that there would be difficulty if and when these identity providers rotate their keys. 

It should be interesting to see how this pans out over the next few years, but there does seem to be promise of improvements in the industry, I am looking forward to it. 

