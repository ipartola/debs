
all: repo/Release.gpg repo/Packages repo/Packages.gz repo/Release \
dists/precise/main/binary-i386 dists/precise/main/binary-amd64 dists/wheezy/main/binary-armhf

clean:
	rm repo/Packages repo/Packages.gz repo/Release.gpg repo/Release
	rm -rf repo/dists

repo/Packages: repo/*.deb
	apt-ftparchive packages repo/ > repo/Packages

repo/Packages.gz: repo/Packages
	cat repo/Packages | gzip -c9 > repo/Packages.gz

repo/Release: repo/Packages.gz repo/Packages apt-release.conf
	apt-ftparchive -c apt-release.conf release repo/ > repo/Release

repo/Release.gpg: repo/Release
	rm -f repo/Release.gpg
	gpg --armor --detach-sign --sign --output repo/Release.gpg repo/Release

dists/precise/main/binary-amd64:
	mkdir -p dists/precise/main/binary-amd64
	cp repo/* dists/precise/main/binary-amd64/

dists/precise/main/binary-i386:
	mkdir -p dists/precise/main/binary-i386
	cp repo/* dists/precise/main/binary-i386/

dists/wheezy/main/binary-armhf:
	mkdir -p dists/wheezy/main/binary-armhf
	cp repo/* dists/wheezy/main/binary-armhf/

