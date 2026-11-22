set -e

cat <<EOF > /opsec-amd64/DEBIAN/control
Package: opsec
Version: 1.0.0
Section: utils
Priority: optional
Architecture: amd64
Depends: libc6, libstdc++6, libgcc-s1
Maintainer: CSH
Description: Activate OPSEC level 1000
EOF

cat <<EOF > /opsec-arm64/DEBIAN/control
Package: opsec
Version: 1.0.0
Section: utils
Priority: optional
Architecture: arm64
Depends: libc6, libstdc++6, libgcc-s1
Maintainer: CSH
Description: Activate OPSEC level 1000
EOF

dpkg-deb --build --root-owner-group /opsec-amd64 /tmp/packages/opsec_1.0.0_amd64.deb
dpkg-deb --build --root-owner-group /opsec-arm64 /tmp/packages/opsec_1.0.0_arm64.deb

mkdir -p "$GNUPGHOME" /repo/conf
chmod 700 "$GNUPGHOME"

echo "$GPG_PRIVATE_KEY_B64" | base64 -d | gpg --batch --import
KEY_ID=$(gpg --list-secret-keys --with-colons | awk -F: '/^sec:/ {print $5; exit}')

if [ -n "$GPG_PASSPHRASE" ]; then
    mkdir -p /root/.gnupg
    echo "allow-loopback-pinentry" > "$GNUPGHOME/gpg-agent.conf"
    gpgconf --kill gpg-agent || true
fi

gpg --armor --output /repo/repo-key.gpg --export "$KEY_ID"

# Publish the freshly built packages into every requested distribution. Each
# codename gets its own stanza in the reprepro distributions file and its own
# Release/Packages metadata under /repo/dists/<codename>, with binaries pooled
# under /repo/pool/.
CODENAMES="$REPO_CODENAMES"

rm -f /repo/conf/distributions
: > /repo/conf/distributions

for codename in $CODENAMES; do
    if [ -s /repo/conf/distributions ]; then
        echo >> /repo/conf/distributions
    fi

    cat <<EOF >> /repo/conf/distributions
Origin: $REPO_ORIGIN
Label: $REPO_ORIGIN
Codename: $codename
Architectures: $REPO_ARCH
Components: main
Description: A simple CSH OPSEC provider.
SignWith: $KEY_ID
EOF

    reprepro -b /repo includedeb "$codename" /tmp/packages/*.deb
done
