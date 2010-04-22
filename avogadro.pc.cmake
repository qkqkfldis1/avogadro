prefix=@USER_PREFIX@
exec_prefix=${prefix}
libdir=${exec_prefix}/@LIB_INSTALL_DIR@
includedir=${prefix}/include
pkgincludedir=${includedir}/avogadro

Name: Avogadro
Description: Avogadro libraries
Version: @Avogadro_VERSION_FULL@
Libs: -L${libdir} -lAvogadroCore -lAvogadroWidget
Cflags: -I${pkgincludedir}
