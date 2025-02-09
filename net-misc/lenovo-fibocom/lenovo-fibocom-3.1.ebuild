# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2 or later

# WWAN Linux support for Fibocom FM350 5G and Fibocom L860R+ LTE modems
#
# https://download.lenovo.com/pccbbs/mobiles_pdf/wwan-enablement-on-Linux.pdf
# https://pcsupport.lenovo.com/us/en/downloads/ds563599-fibocom-wireless-wan-l860-gl-16-fcc-unlock-and-sar-config-tool-for-linux-thinkpad

EAPI=8


inherit systemd

DESCRIPTION="FCC unlock for Fibocom L860R+ LTE and Fibocom FM350 5G modem"
HOMEPAGE="https://download.lenovo.com/pccbbs/mobiles_pdf/wwan-enablement-on-Linux.pdf"

ZIP_VER=04
INNER_VER=2.1

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://download.lenovo.com/pccbbs/mobiles/n3xwp${ZIP_VER}w.zip -> ${P}.zip"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="Lenovo-COE-30002-01"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND="net-misc/modemmanager[mbim]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/lenovo-wwan-unlock"

src_unpack() {
	# the outer lenovo zip file
	unpack ${A}
	# the actual fccunlock_package file
	unpack ${WORKDIR}/lenovo-wwan-unlock_ver${INNER_VER}.tar.gz

	cd $S
	unpack $S/fcc-unlock.d.tar.gz
	unpack $S/sar_config_files.tar.gz
}

src_configure() {
	# fix location of executables
	sed -ri 's|^./opt/fcc_lenovo|/opt/fcc_lenovo|g' fcc-unlock.d/*
}

src_install() {
	dolib.so libmodemauth.so
	dolib.so libconfigserviceR+.so
	dolib.so libconfigservice350.so
	dolib.so libmbimtools.so

	exeinto /opt/fcc_lenovo
	doexe DPR_Fcc_unlock_service

	insinto /opt/fcc_lenovo
	doins -r sar_config_files/

	# apparently the "configservice" is not needed?
	#systemd_dounit lenovo-cfgservice.service
	#doexe configservice_lenovo

	exeinto /usr/share/ModemManager/fcc-unlock.available.d
	pushd fcc-unlock.d
		chmod +x *
		doexe *
	popd

}

pkg_postinst() {
	einfo "To use your Lenovo WWAN modem:"
	einfo "Don't forget to link your modem's id (lspci) from"
	einfo "/usr/share/ModemManager/fcc-unlock.available.d/... to"
	einfo "/etc/ModemManager/fcc-unlock.d/..."
	einfo "see: https://modemmanager.org/docs/modemmanager/fcc-unlock/"
}
