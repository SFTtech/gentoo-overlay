# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="git://github.com/SFTtech/${PN}.git https://github.com/SFTtech/${PN}.git"
fi

CABAL_FEATURES="bin profile haddock hscolour hoogle test-suite"

inherit games haskell-cabal ${SCM}

DESCRIPTION="Masterserver for matchmaking and lobby mediating for openage"
HOMEPAGE="http://openage.sft.mx/ https://github.com/SFTtech/openage-masterserver"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
else # Official release
	SRC_URI="https://github.com/SFTtech/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
dev-haskell/aeson:=[profile?]
dev-haskell/hdbc-postgresql:=[profile?]
dev-haskell/hdbc:=[profile?]
dev-haskell/network:=[profile?]
dev-haskell/parsec:=[profile?]
dev-haskell/text:=[profile?]
dev-haskell/utf8-string:=[profile?]
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch_user
}

src_install() {
	cabal_src_install

	dodoc README.md
}

