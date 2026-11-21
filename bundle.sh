set -e

cat <<EOF > /opsec-build/DEBIAN/control
Package: opsec
Version: 1.0.0
Section: utils
Priority: optional
Architecture: arm64
Depends: libc6, libstdc++6, libgcc-s1
Maintainer: CSH
Description: Activate OPSEC level 1000
EOF

dpkg-deb --build --root-owner-group /opsec-build /tmp/packages/opsec_1.0.0_arm64.deb

mkdir -p "$GNUPGHOME" /repo/conf
chmod 700 "$GNUPGHOME"

echo "$GPG_PRIVATE_KEY_B64" | base64 -d | gpg --batch --import
KEY_ID=$(gpg --list-secret-keys --with-colons | awk -F: '/^sec:/ {print $5; exit}')

if [ -n "$GPG_PASSPHRASE" ]; then
    mkdir -p /root/.gnupg
    echo "allow-loopback-pinentry" > "$GNUPGHOME/gpg-agent.conf"
    gpgconf --kill gpg-agent || true
fi

cat <<EOF > /repo/conf/distributions
Origin: $REPO_ORIGIN
Label: $REPO_ORIGIN
Codename: $REPO_CODENAME
Architectures: $REPO_ARCH
Components: main
Description: A simple CSH OPSEC provider.
SignWith: $KEY_ID
EOF

gpg --armor --output /repo/repo-key.gpg --export "$KEY_ID"
reprepro -b /repo includedeb "$REPO_CODENAME" /tmp/packages/*.deb
