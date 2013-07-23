
all: dists/precise/Release.gpg dists/precise/Release.gpg dists/wheezy/Release.gpg

clean:
	rm -f repo/Packages repo/Packages.gz
	rm -rf dists

dists/precise/Release: dists/precise/main/binary-amd64 dists/precise/main/binary-i386
	apt-ftparchive -c apt-release.conf release dists/precise > dists/precise/Release

dists/precise/Release.gpg: dists/precise/Release
	rm -f dists/precise/Release.gpg
	gpg --armor --detach-sign --sign --output dists/precise/Release.gpg dists/precise/Release

dists/wheezy/Release: dists/wheezy/main/binary-armhf
	apt-ftparchive -c apt-release.conf release dists/wheezy > dists/wheezy/Release

dists/wheezy/Release.gpg: dists/wheezy/Release
	rm -f dists/wheezy/Release.gpg
	gpg --armor --detach-sign --sign --output dists/wheezy/Release.gpg dists/wheezy/Release

repo/Packages: repo/*.deb
	apt-ftparchive packages repo/ > repo/Packages

repo/Packages.gz: repo/Packages
	cat repo/Packages | gzip -c9 > repo/Packages.gz

dists/precise/main/binary-amd64: repo/Packages.gz
	mkdir -p dists/precise/main/binary-amd64
	cp repo/* dists/precise/main/binary-amd64/

dists/precise/main/binary-i386: repo/Packages.gz
	mkdir -p dists/precise/main/binary-i386
	cp repo/* dists/precise/main/binary-i386/

dists/wheezy/main/binary-armhf: repo/Packages.gz
	mkdir -p dists/wheezy/main/binary-armhf
	cp repo/* dists/wheezy/main/binary-armhf/

