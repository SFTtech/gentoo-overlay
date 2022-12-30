# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/SFTtech/${PN}.git"
fi

inherit systemd ${SCM}

DESCRIPTION="automatic keyboard repeat rate configuration"


HOMEPAGE="https://github.com/SFTtech/xautocfg"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/SFTtech/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="GPL-3"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND="
	x11-libs/libXi
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_install() {
	dobin xautocfg
	dodoc README.md
	doman xautocfg.1
	dodoc etc/xautocfg.cfg
	systemd_douserunit etc/xautocfg.service
}
