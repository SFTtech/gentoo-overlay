# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="El Torito boot image extractor"
HOMEPAGE="http://userpages.uni-koblenz.de/~krienke/ftp/noarch/geteltorito/"
SRC_URI="https://userpages.uni-koblenz.de/~krienke/ftp/noarch/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
dev-lang/perl
${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	dobin geteltorito
}
