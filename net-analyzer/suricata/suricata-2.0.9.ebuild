# Distributed under the terms of the GNU General Public License v3 or later

EAPI=5

inherit eutils autotools user systemd

DESCRIPTION="next generation intrusion detection and prevention engine"
HOMEPAGE="http://www.openinfosecfoundation.org"
SRC_URI="https://github.com/inliniac/${PN}/archive/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="+af-packet +json +nfqueue +prelude caps control-socket cuda debug geoip
      hardened lua luajit nflog pfring static-libs +system-htp test +rules"

REQUIRED_USE="
	control-socket? ( json )
"

RDEPEND="
>=dev-libs/jansson-2.2
dev-libs/libpcre
dev-libs/libyaml
net-libs/libnet
net-libs/libnfnetlink
dev-libs/nspr
dev-libs/nss
net-libs/libpcap
sys-apps/file
caps?       ( sys-libs/libcap-ng )
cuda?       ( dev-util/nvidia-cuda-toolkit )
geoip?      ( dev-libs/geoip )
json?       ( dev-libs/jansson )
luajit?     ( dev-lang/luajit )
nflog?      ( net-libs/libnetfilter_log )
nfqueue?    ( net-libs/libnetfilter_queue )
pfring?     ( net-libs/pfring )
prelude?    ( dev-libs/libprelude )
test?       ( dev-util/coccinelle )
system-htp? ( >=net-analyzer/htp-0.5.5 )
"

DEPEND="
${RDEPEND}
"

S="${WORKDIR}/${PN}-${P}"


pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} "${PN}"
}

src_prepare() {
	epatch "${FILESDIR}/fix-autocancer-features.patch"
	epatch "${FILESDIR}/fortify_source-numeric.patch"
	epatch "${FILESDIR}/json-header.patch"
	epatch "${FILESDIR}/magic-location.patch"

	epatch_user

	_elibtoolize
	eaclocal
	eautoheader
	eautomake
	eautoconf
}

src_configure() {
	local myeconfargs=(
		--localstatedir=/var
		$(use_enable control-socket unix-socket)
		$(use_enable system-htp non-bundled-htp)
		$(use_enable static-libs static)
		$(use_enable af-packet)
		$(use_enable pfring)
		$(use_enable hardened gccprotect)
		$(use_enable nfqueue)
		$(use_enable cuda)
		$(use_enable debug)
		$(use_enable json jansson)
		$(use_enable lua)
		$(use_enable luajit)
		$(use_enable geoip)
		$(use_enable prelude)
		$(use_enable test coccinelle)
		$(use_enable test unittests)
		"$(systemd_with_unitdir)"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /etc/${PN}
	doins ${PN}.yaml
	doins classification.config
	doins reference.config
	doins threshold.config

	if use rules; then
		insinto /etc/${PN}/rules
		doins rules/decoder-events.rules
		doins rules/stream-events.rules
		doins rules/smtp-events.rules
		doins rules/http-events.rules
		doins rules/dns-events.rules
	else
		keepdir /etc/${PN}/rules
	fi

	# TODO: fix folder ownage
	diropts -m0750 -o ${PN} -g ${PN}
	keepdir /var/lib/${PN}/

	diropts -m0750 -o ${PN} -g ${PN}
	keepdir /var/log/${PN}/

	diropts -m0750 -o ${PN} -g ${PN}
	keepdir /var/log/${PN}/certs

	systemd_dounit ${FILESDIR}/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}/${PN}.tmpfiles" ${PN}.conf
}
