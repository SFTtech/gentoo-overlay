# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4,3_5,3_6} pypy3 )

inherit distutils-r1

DESCRIPTION="cowsay reimplemention for ponies"
HOMEPAGE="http://erkin.github.com/ponysay/"
SRC_URI="https://github.com/erkin/ponysay/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

IUSE='doc bash-completion fish-completion zsh-completion -strict-license'

DEPEND='doc? ( sys-apps/texinfo )
app-arch/gzip
sys-devel/make
sys-apps/sed'

RDEPEND='sys-apps/coreutils
bash-completion? ( app-shells/bash )
fish-completion? ( app-shells/fish )
zsh-completion? ( app-shells/zsh )'

# pony-licensing
check_strictness() {
	if use strict-license; then
		freedom="strict"
	else
		freedom="partial"
	fi
	export freedom
}

# the shittiest setup.py script award goes to: ponysay!
get_setup_args() {
	check_strictness
	echo -n "--prefix=/usr \
		$(use_with doc pdf) \
		$(use_with doc info) \
		$(use_with bash-completion) \
		$(use_with fish-completion) \
		$(use_with zsh-completion) \
		--freedom=$freedom \
	"
}

src_compile() {
	esetup.py \
		$(get_setup_args) \
		build
}

src_install() {
	esetup.py \
		--destdir=${D} \
		$(get_setup_args) \
		prebuilt
}
