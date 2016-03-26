dnl Common configure.ac fragment
dnl
dnl   Copyright (C) 2012-2016 Free Software Foundation, Inc.
dnl
dnl This file is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 3 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program; see the file COPYING3.  If not see
dnl <http://www.gnu.org/licenses/>.
dnl

AC_DEFUN([AM_BINUTILS_WARNINGS],[
# Set the 'development' global.
. $srcdir/../bfd/development.sh

# Default set of GCC warnings to enable.
GCC_WARN_CFLAGS="-W -Wall -Wstrict-prototypes -Wmissing-prototypes"
GCC_WARN_CXXFLAGS="-W -Wall"

# Add -Wshadow if the compiler is a sufficiently recent version of GCC.
AC_EGREP_CPP([^[0-3]$],[__GNUC__],,GCC_WARN_CFLAGS="$GCC_WARN_CFLAGS -Wshadow")

# Add -Wstack-usage if the compiler is a sufficiently recent version of GCC.
AC_EGREP_CPP([^[0-4]$],[__GNUC__],,GCC_WARN_CFLAGS="$GCC_WARN_CFLAGS -Wstack-usage=262144")
AC_EGREP_CPP([^[0-4]$],[__GNUC__],,GCC_WARN_CXXFLAGS="$GCC_WARN_CXXFLAGS -Wstack-usage=262144")

# Set WARN_WRITE_STRINGS if the compiler supports -Wwrite-strings.
WARN_WRITE_STRINGS=""
AC_EGREP_CPP([^[0-3]$],[__GNUC__],,WARN_WRITE_STRINGS="-Wwrite-strings")

AC_ARG_ENABLE(werror,
  [  --enable-werror         treat compile warnings as errors],
  [case "${enableval}" in
     yes | y) ERROR_ON_WARNING="yes" ;;
     no | n)  ERROR_ON_WARNING="no" ;;
     *) AC_MSG_ERROR(bad value ${enableval} for --enable-werror) ;;
   esac])

# Disable -Wformat by default when using gcc on mingw
case "${host}" in
  *-*-mingw32*)
    if test "${GCC}" = yes -a -z "${ERROR_ON_WARNING}" ; then
      GCC_WARN_CFLAGS="$GCC_WARN_CFLAGS -Wno-format"
      GCC_WARN_CXXFLAGS="$GCC_WARN_CXXFLAGS -Wno-format"
    fi
    ;;
  *) ;;
esac

# Enable -Werror by default when using gcc.  Turn it off for releases.
if test "${GCC}" = yes -a -z "${ERROR_ON_WARNING}" -a "$development" = true ; then
    ERROR_ON_WARNING=yes
fi

NO_WERROR=
if test "${ERROR_ON_WARNING}" = yes ; then
    GCC_WARN_CFLAGS="$GCC_WARN_CFLAGS -Werror"
    GCC_WARN_CXXFLAGS="$GCC_WARN_CXXFLAGS -Werror"
    NO_WERROR="-Wno-error"
fi

if test "${GCC}" = yes ; then
  WARN_CFLAGS="${GCC_WARN_CFLAGS}"
  WARN_CXXFLAGS="${GCC_WARN_CXXFLAGS}"
fi

AC_ARG_ENABLE(build-warnings,
[  --enable-build-warnings enable build-time compiler warnings],
[case "${enableval}" in
  yes)	WARN_CFLAGS="${GCC_WARN_CFLAGS}" WARN_CXXFLAGS="${GCC_WARN_CXXFLAGS}";;
  no)	if test "${GCC}" = yes ; then
	  WARN_CFLAGS="-w"
	  WARN_CXXFLAGS="-w"
	fi;;
  ,*)   t=`echo "${enableval}" | sed -e "s/,/ /g"`
        WARN_CFLAGS="${GCC_WARN_CFLAGS} ${t}";;
  *,)   t=`echo "${enableval}" | sed -e "s/,/ /g"`
        WARN_CFLAGS="${t} ${GCC_WARN_CFLAGS}" WARN_CXXFLAGS="${t} ${GCC_WARN_CXXFLAGS}";;
  *)    t=`echo "${enableval}" | sed -e "s/,/ /g"`
    WARN_CFLAGS="${t}" WARN_CXXFLAGS="${t}";;
esac])

if test x"$silent" != x"yes" && test x"$WARN_CFLAGS" != x""; then
  echo "Setting C warning flags = $WARN_CFLAGS" 6>&1
  echo "Setting C++ warning flags = $WARN_CXXFLAGS" 6>&1
fi

AC_SUBST(WARN_CFLAGS)
AC_SUBST(WARN_CXXFLAGS)
AC_SUBST(NO_WERROR)
     AC_SUBST(WARN_WRITE_STRINGS)
])
