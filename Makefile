S3_LOCATION="s3://debs.ridgebit.net/qoSBonHMiqBNAAe5TNm3M0PuZaV91peH/"

all: upload

clean:
	rm -rf dists

upload: dists/custom/Release.gpg dists/public.key 
	s3cmd sync --no-preserve dists $(S3_LOCATION)

dists/public.key:
	mkdir -p dists
	cp public.key dists/

dists/custom/Release: dists/custom/main/binary-amd64/Packages.gz dists/custom/main/binary-i386/Packages.gz dists/custom/main/binary-armhf/Packages.gz
	apt-ftparchive -c apt-release.conf release dists/custom > dists/custom/Release

dists/custom/Release.gpg: dists/custom/Release
	rm -f dists/custom/Release.gpg
	gpg --armor --detach-sign --sign --output dists/custom/Release.gpg dists/custom/Release

dists/custom/main/binary-amd64: repo/*.deb
	rm -rf dists/custom/main/binary-amd64
	mkdir -p dists/custom/main/binary-amd64
	cp repo/*_amd64.deb repo/*_all.deb dists/custom/main/binary-amd64/

dists/custom/main/binary-i386: repo/*.deb
	rm -rf dists/custom/main/binary-i386
	mkdir -p dists/custom/main/binary-i386
	cp repo/*_i386.deb repo/*_all.deb dists/custom/main/binary-i386/

dists/custom/main/binary-armhf: repo/*.deb
	rm -rf dists/custom/main/binary-armhf
	mkdir -p dists/custom/main/binary-armhf
	cp repo/*_armhf.deb repo/*_all.deb dists/custom/main/binary-armhf/

dists/custom/main/binary-amd64/Packages: dists/custom/main/binary-amd64/
	apt-ftparchive packages dists/custom/main/binary-amd64/ > dists/custom/main/binary-amd64/Packages

dists/custom/main/binary-amd64/Packages.gz: dists/custom/main/binary-amd64/Packages
	cat dists/custom/main/binary-amd64/Packages | gzip -c9 > dists/custom/main/binary-amd64/Packages.gz

dists/custom/main/binary-i386/Packages: dists/custom/main/binary-i386/
	apt-ftparchive packages dists/custom/main/binary-i386/ > dists/custom/main/binary-i386/Packages

dists/custom/main/binary-i386/Packages.gz: dists/custom/main/binary-i386/Packages
	cat dists/custom/main/binary-i386/Packages | gzip -c9 > dists/custom/main/binary-i386/Packages.gz

dists/custom/main/binary-armhf/Packages: dists/custom/main/binary-armhf/
	apt-ftparchive packages dists/custom/main/binary-armhf/ > dists/custom/main/binary-armhf/Packages

dists/custom/main/binary-armhf/Packages.gz: dists/custom/main/binary-armhf/Packages
	cat dists/custom/main/binary-armhf/Packages | gzip -c9 > dists/custom/main/binary-armhf/Packages.gz

