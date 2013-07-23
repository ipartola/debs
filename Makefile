
all: repo/Release.gpg repo/Packages repo/Packages.gz repo/Release repo/dists/precise/main/binary-i386 repo/dists/precise/main/binary-amd64

repo/Packages: repo/*.deb
	apt-ftparchive packages repo/ > repo/Packages

repo/Packages.gz: repo/Packages
	cat repo/Packages | gzip -c9 > repo/Packages.gz

repo/Release: repo/Packages.gz repo/Packages apt-release.conf
	apt-ftparchive -c apt-release.conf release repo/ > repo/Release

repo/Release.gpg: repo/Release
	rm -f repo/Release.gpg
	gpg --armor --detach-sign --sign --output repo/Release.gpg repo/Release

repo/dists/precise/main/binary-amd64:
	mkdir -p repo/dists/precise/main
	ln -s ../../../ repo/dists/precise/main/binary-amd64

repo/dists/precise/main/binary-i386:
	mkdir -p repo/dists/precise/main
	ln -s ../../../ repo/dists/precise/main/binary-i386

clean:
	rm repo/Packages repo/Packages.gz repo/Release.gpg repo/Release

