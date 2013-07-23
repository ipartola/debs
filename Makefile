
all: dists/custom/Release.gpg

clean:
	rm -f repo/Packages repo/Packages.gz
	rm -rf dists

dists/custom/Release: dists/custom/main/binary-amd64 dists/custom/main/binary-i386 dists/custom/main/binary-armhf
	apt-ftparchive -c apt-release.conf release dists/custom > dists/custom/Release

dists/custom/Release.gpg: dists/custom/Release
	rm -f dists/custom/Release.gpg
	gpg --armor --detach-sign --sign --output dists/custom/Release.gpg dists/custom/Release

repo/Packages: repo/*.deb
	apt-ftparchive packages repo/ > repo/Packages

repo/Packages.gz: repo/Packages
	cat repo/Packages | gzip -c9 > repo/Packages.gz

dists/custom/main/binary-amd64: repo/Packages.gz
	mkdir -p dists/custom/main/binary-amd64
	cp repo/* dists/custom/main/binary-amd64/

dists/custom/main/binary-i386: repo/Packages.gz
	mkdir -p dists/custom/main/binary-i386
	cp repo/* dists/custom/main/binary-i386/

dists/custom/main/binary-armhf: repo/Packages.gz
	mkdir -p dists/custom/main/binary-armhf
	cp repo/* dists/custom/main/binary-armhf/

