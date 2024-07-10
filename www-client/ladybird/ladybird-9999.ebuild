# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/LadybirdBrowser/${PN}.git"
fi

inherit cmake ${SCM}

DESCRIPTION="Truly independent web browser"
HOMEPAGE="https://ladybird.dev https://github.com/LadybirdBrowser/ladybird"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/LadybirdBrowser/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

## hardcoded versions

# /Meta/CMake/public_suffix.cmake
# they use the master branch, but we want a reproducible build
PSL_VERSION=6a1ef4345e2e8a54542fa1e58087797ac118fdd7

# /Meta/CMake/time_zone_data.cmake
TZDB_VERSION=2024a

# /Meta/CMake/unicode_data.cmake
UCD_VERSION=15.1.0

# /Meta/CMake/locale_data.cmake
CLDR_VERSION=45.0.0

# oh dear, removes the third .\d suffix.
# also done in unicode_data.cmake
UCD_VERSION_MINOR=${UCD_VERSION%.*}

SRC_URI="
${SRC_URI}
https://github.com/publicsuffix/list/raw/${PSL_VERSION}/public_suffix_list.dat -> ${P}-public_suffix_list-${PSL_VERSION}.dat
https://www.unicode.org/Public/${UCD_VERSION}/ucd/UCD.zip -> ${P}-UCD-${UCD_VERSION}.zip
https://www.unicode.org/Public/emoji/${UCD_VERSION_MINOR}/emoji-test.txt -> ${P}-emoji-test-${UCD_VERSION}.txt
https://www.unicode.org/Public/idna/${UCD_VERSION}/IdnaMappingTable.txt -> ${P}-IdnaMappingTable-${UCD_VERSION_MINOR}.txt
https://github.com/unicode-org/cldr-json/releases/download/${CLDR_VERSION}/cldr-${CLDR_VERSION}-json-modern.zip -> ${P}-cldr-${CLDR_VERSION}-json-modern.zip
https://data.iana.org/time-zones/releases/tzdata${TZDB_VERSION}.tar.gz -> ${P}-tzdata-${TZDB_VERSION}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
IUSE="test"
REQUIRED_USE=""

RDEPEND="
dev-qt/qtbase:6[gui,widgets,network]
media-libs/woff2
dev-libs/icu
virtual/opengl
virtual/libcrypt
media-libs/fontconfig
"
DEPEND="${RDEPEND}"
BDEPENT="
virtual/pkgconfig
app-misc/ca-certificates
"

cp_cachefile() {
	# usage: cp_cachefile <in-distdir-path> <in-cache-directory-path>

	local src="${DISTDIR}/$1"
	local dst="${BUILD_DIR}/caches/$2"

	local dirname=$(dirname "$dst")
	mkdir -p $dirname || die "failed to create parent dir $dirname"
	cp "$src" "$dst" || die "failed to copy $src -> $dst"
}

extract_cachefile() {
	# usage extract_cachefile <in-distdir-archive-path> <in-cache-directory-path>

	local src="$1"
	local dst="${BUILD_DIR}/caches/$2"

	mkdir -p $dst

	cd $dst
	unpack $src || die "failed to extract $src -> $dst"
}

src_prepare() {
	cmake_src_prepare

	local cachedir="${BUILD_DIR}/caches"

	# by default, the build downloads https://curl.se/ca/
	# the version suffix is hardcoded in Meta/CMake/ca_certificates_data.cmake as CACERT_FILE...
	mkdir -p $cachedir/CACERT
	local CACERT_VERSION=2023-12-12
	ln -s /etc/ssl/certs/ca-certificates.crt $cachedir/CACERT/cacert-${CACERT_VERSION}.pem
	echo "$CACERT_VERSION" > $cachedir/CACERT/version.txt

	cp_cachefile "${P}-public_suffix_list-${PSL_VERSION}.dat" PublicSuffix/public_suffix_list.dat

	extract_cachefile "${P}-tzdata-${TZDB_VERSION}.tar.gz" TZDB/
	echo "$TZDB_VERSION" > $cachedir/TZDB/version.txt

	extract_cachefile "${P}-UCD-${UCD_VERSION}.zip" UCD/
	cp_cachefile "${P}-emoji-test-${UCD_VERSION}.txt" UCD/emoji-test.txt
	cp_cachefile "${P}-IdnaMappingTable-${UCD_VERSION_MINOR}.txt" UCD/IdnaMappingTable.txt
	echo "$UCD_VERSION" > $cachedir/UCD/version.txt

	extract_cachefile "${P}-cldr-${CLDR_VERSION}-json-modern.zip" CLDR/
	echo "$CLDR_VERSION" > $cachedir/CLDR/version.txt
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_QT=True
		-DBUILD_TESTING="$(usex test True False)"
		-DENABLE_NETWORK_DOWNLOADS=False
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# some test files from /Userland/Libraries/LibWasm/CMakeLists.txt
	rm -rf "${D}/usr/home"
}
