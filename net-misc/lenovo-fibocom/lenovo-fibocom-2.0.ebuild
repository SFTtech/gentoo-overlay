# Copyright 2023-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2 or later

# WWAN Linux support for Fibocom FM350 and Fibocom L860R+
#
# https://download.lenovo.com/pccbbs/mobiles_pdf/wwan-enablement-on-Linux.pdf
# https://pcsupport.lenovo.com/us/en/downloads/ds563599-fibocom-wireless-wan-l860-gl-16-fcc-unlock-and-sar-config-tool-for-linux-thinkpad

EAPI=8


inherit systemd

DESCRIPTION="FCC unlock for Fibocom L860R+ and Fibocom FM350 5G"
HOMEPAGE=""

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	KEYWORDS=""
else
	# insert just the major version - let's see how the zip files will be named in the future...
	SRC_URI="
	https://download.lenovo.com/pccbbs/mobiles/n3xwp0${PV%.*}w.zip -> ${P}.zip
	"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="Lenovo-COE-30002-01"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND="net-misc/modemmanager[mbim]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/lenovo_wwan_fccunlock_package"

src_unpack() {
	# the outer lenovo zip file
	unpack ${A}
	# the actual fccunlock_package file
	unpack ${WORKDIR}/lenovo_wwan_fccunlock_package_${PV}.tar.gz
}

src_configure() {
	# fix location of executables
	sed -ri 's|^./opt/fcc_lenovo|/opt/fcc_lenovo|g' fcc-unlock.d/*
}

src_install() {
	dolib.so libmodemauth.so
	dolib.so libconfigserviceR+.so
	dolib.so libconfigservice350.so

	exeinto /opt/fcc_lenovo
	doexe DPR_Fcc_unlock_service

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
