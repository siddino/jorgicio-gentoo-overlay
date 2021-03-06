# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="Epson Stylus CX4300/CX4400/CX5600/DX4400 scanner plugin for SANE epkowa backend"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="
	x86? ( http://alumnos.inf.utfsm.cl/~jpizarro/avasys/${PN}_${PV}-1_i386.deb )
	amd64? ( http://alumnos.inf.utfsm.cl/~jpizarro/avasys/${PN}_${PV}-1_amd64.deb )"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

DEPEND=">=media-gfx/iscan-2.28.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PRESTRIPPED="/usr/lib/iscan/libesint7E.so.2.0.0"

src_unpack(){
	unpack_deb ${A}
}

src_install() {
	exeinto /usr/$(get_libdir)/iscan
	doexe usr/lib/iscan/libesint7E.so.2.0.0
	rm usr/lib/iscan/libesint7E.so.2.0.0
	#dosym /usr/$(get_libdir)/iscan/libesint7E.so.2.0.0 /usr/$(get_libdir)/iscan/libesint7E.so
	#dosym /usr/$(get_libdir)/iscan/libesint7E.so.2.0.0 /usr/$(get_libdir)/iscan/libesint7E.so.2
	insinto /usr/$(get_libdir)/iscan
	doins usr/lib/iscan/*
	dodoc usr/share/doc/*/*
}

pkg_postinst() {
	elog "Registering the scanner..."
	iscan-registry --add interpreter usb 0x04b8 0x083f "/usr/$(get_libdir)/iscan/libesint7E.so"
}

pkg_prerm() {
	elog "Unregistering the scanner..."
	iscan-registry --remove interpreter usb 0x04b8 0x083f "/usr/$(get_libdir)/iscan/libesint7E.so"
}
