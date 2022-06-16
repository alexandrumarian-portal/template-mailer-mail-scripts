### Description

This repository is set of scripts that allow to spin and partially manage a
mail server environment in fully automated way.

The default configuration:

- IPv4
- SMTP at 25, 465 and 587.
- IMAP at 993.
- Enforcing TLS on every port.
- Virtual domains, mailboxes, users and aliases.
- Firewall allowing only ports 22, 25, 465, 587, 993.
- Connected with OpenDKIM.
- Connected with SpamAssassin.
- Restrictive relay only on behalf of the authenticated users.
- Restrictive MAIL FROM policy for addresses that belong to this mail server.
    - Only authenticated users that own MAIL FROM address directly or by an
      alias can use it.
- Set RBLs:
    - b.barracudacentral.org
    - zen.spamhaus.org
    - bl.spamcop.net

### Distributions

List of tested distributions:

- Ubuntu 22.04 LTS, Linux 5.15.0-33-generic

Note that the scripts should run on the new machine, at least that is the
assumption. Consider running this in a Docker container.

### Installation

Before proceeding with the installation, it is necessary to obtain TLS
certificates and their private keys for the mail server.

For the purposes of this manual, this is assumed to be out of scope as there are
many high-quality tutorials outside the Internet which cover this topic.

Clone the repository:

```shell
git clone https://github.com/milosob/template-mailer.git
```

Open the repository directory:

```shell
cd template-mailer
```

Create a configuration file based on the template:

```shell
cp config.template.sh config.sh
```

The configuration file is expected to be found in the root of repository.

Adjust the default configuration, In most cases it is enough to replace every
occurrence of `example.com` in the configuration file with the desired domain:

```shell
sed -i 's/example.com/domain.com/g' config.sh
```

The default configuration assumes:

- The machine where the mail sever is being installed at, is going to be
  reachable at `mail.domain.com`.
- Certbot was used to generate TLS certificates, and they can be found at
  default location.

If it is not the case, modify were `TLS_CERT` and `TLS_CERT_KEY` in the
configuration point at:

```shell
sed -i "s/TLS_CERT=.*/TLS_CERT=path-to-cert/g" config.sh
sed -i "s/TLS_CERT_KEY=.*/TLS_CERT=path-to-cert-key/g" config.sh
```

Install the mail server:

```shell
bash install.sh
```

Remember configure DNS records:

- MX
- SFP
- DKIM
- DMARC

### Management

There are some handy scripts to help take certain actions in the context of the
mail server.

#### DKIM

To configure DKIM signing and verifying for one of the domain the mail server is
responsible for:

```shell
bash.sh add_dkim domain.com mail
```

Note:

- Invoking the above command will generate and load a new DKIM key pair for the
  domain unless they already exist.
- Upon success the DKIM raw DNS record will be printed.

#### Users

To add a user:

```shell
bash add_user.sh domain.com user@domain.com password
```

----
To delete a user:

```shell
bash del_user.sh user@domain.com
```

Note:

- Deleting a user removes all his aliases.

----
To add a user alias:

```shell
bash add_user.sh domain.com user@domain.com alias@domain.com
```

Note:

- In the default configuration it is not possible to use the MAIL_FROM address
  which a user does not own or share.
- To send as the MAIL_FROM, user must have the MAIL_FROM configured as an alias.

----
To delete a user alias:

```shell
bash del_alias.sh user@domain.com alias@domain.com
```
