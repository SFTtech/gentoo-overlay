# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils user systemd

DESCRIPTION="High performance Network IDS, IPS and Network Security Monitoring engine"
HOMEPAGE="http://suricata-ids.org/"
SRC_URI="http://www.openinfosecfoundation.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="+af-packet control-socket caps cuda debug geoip hardened +json lua luajit nflog +nfqueue pfring +prelude static-libs +system-htp +rules test"

REQUIRED_USE="
	control-socket? ( json )
"

DEPEND="
	>=dev-libs/jansson-2.2
	dev-libs/libpcre
	dev-libs/libyaml
	net-libs/libnet:*
	net-libs/libnfnetlink
	dev-libs/nspr
	dev-libs/nss
	net-libs/libpcap
	sys-apps/file
	caps?       ( sys-libs/libcap-ng )
	cuda?       ( dev-util/nvidia-cuda-toolkit )
	geoip?      ( dev-libs/geoip )
	json?       ( dev-libs/jansson )
	lua?        ( dev-lang/lua:* )
	luajit?     ( dev-lang/luajit:* )
	nflog?      ( net-libs/libnetfilter_log )
	nfqueue?    ( net-libs/libnetfilter_queue )
	pfring?     ( net-libs/pfring )
	prelude?    ( dev-libs/libprelude )
	test?       ( dev-util/coccinelle )
	system-htp? ( >=net-analyzer/htp-0.5.5 )
"

RDEPEND="${DEPEND}"

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

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		"--localstatedir=/var/"
		$(use_enable af-packet)
		$(use_enable control-socket unix-socket)
		$(use_enable cuda)
		$(use_enable debug)
		$(use_enable geoip)
		$(use_enable hardened gccprotect)
		$(use_enable json jansson)
		$(use_enable lua)
		$(use_enable luajit)
		$(use_enable nfqueue)
		$(use_enable pfring)
		$(use_enable prelude)
		$(use_enable static-libs static)
		$(use_enable system-htp non-bundled-htp)
		$(use_enable test coccinelle)
		$(use_enable test unittests)
		"$(systemd_with_unitdir)"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	insinto "/etc/${PN}"
	doins {classification,reference,threshold}.config suricata.yaml

	if use rules ; then
		insinto "/etc/${PN}/rules"
		doins rules/*.rules
	else
		keepdir "/etc/${PN}/rules"
	fi

	dodir "/var/lib/${PN}"
	dodir "/var/log/${PN}"
	fowners -R ${PN}: "/var/lib/${PN}" "/var/log/${PN}" "/etc/${PN}"
	fperms 750 "/var/lib/${PN}" "/var/log/${PN}" "/etc/${PN}"

	systemd_dounit ${FILESDIR}/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}/${PN}.tmpfiles" ${PN}.conf
}
