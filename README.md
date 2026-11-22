opsec
=====

opsec is an apt repository that you can add to your debian-based machine to install opsec whenever you want!

# Installation
To add the repo to your machine you first need to add the repo's public key into your system's keyring so it can validate the binary.

Create the the keyring directory if it doesn't already exist.
```bash
sudo mkdir -p /etc/apt/keyrings
```

Next you'll want to download the public key from CSH's servers, this does require that you have the `gnupg` package installed to decode the key.
```bash
curl -fsSL https://opsec.cs.house | sudo gpg --dearmor -o /etc/apt/keyrings/csh-opsec.gpg
```

Then you'll need to make sure the key is readable by all users on the machine, not just root.
```bash
sudo chmod a+r /etc/apt/keyrings/csh-opsec.gpg
```

Now that you have the public key installed in your system you will need to add the actual repo information to your apt, this is accomplished by creating a file at `/etc/apt/sources.list.d/csh-opsec.source` with the contents below.
You will need to change the `Suites` value to be that of your actual distro's major release.
```
Types: deb
URIs: https://opsec.cs.house
Suites: <Your distro's codename (eg. 'trixie' for Debian 13, 'resolute' for Ubuntu 26.04)>
Components: main
Signed-By: /etc/apt/keyrings/csh-opsec.gpg
```

# Usage
After you have added the gpg key to your keyring and added the repository's source information you can now install any package from it!

To achieve greatness, now run this command to install opsec onto your machine.
```bash
sudo apt install opsec
```

Once you install opsec, you can simply run it by executing the binary.
```bash
opsec
```
