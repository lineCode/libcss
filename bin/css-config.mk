#! /bin/sh

version=0.0.1
prefix=/usr
exec_prefix=${prefix}
includedir=${prefix}/include
libdir=/usr/lib64

usage()
{
    cat <<EOF
Usage: css-config [OPTION]

Known values for OPTION are:

  --prefix=DIR		change libcss prefix [default $prefix]
  --exec-prefix=DIR	change libcss exec prefix [default $exec_prefix]
  --libs		print library linking information
  --cflags		print pre-processor and compiler flags
  --modules		module support enabled
  --help		display this help and exit
  --version		output version information
EOF

    exit $1
}

if test $# -eq 0; then
    usage 1
fi

cflags=false
libs=false

while test $# -gt 0; do
    case "$1" in
    -*=*) optarg=`echo "$1" | sed 's/[-_a-zA-Z0-9]*=//'` ;;
    *) optarg= ;;
    esac

    case "$1" in
    --prefix=*)
	prefix=$optarg
	includedir=$prefix/include
	libdir=$prefix/lib
	;;

    --prefix)
	echo $prefix
	;;

    --exec-prefix=*)
      exec_prefix=$optarg
      libdir=$exec_prefix/lib
      ;;

    --exec-prefix)
      echo $exec_prefix
      ;;

    --version)
	echo $version
	exit 0
	;;

    --help)
	usage 0
	;;

    --cflags)
       	echo -I${includedir}/css %SELECTOR_ENABLED_CFLAGS%
       	;;

    --modules)
       	echo 1
       	;;

    --libs)
        if [ "`uname`" = "Linux" ]
	then
	    if [ "-L${libdir}" = "-L/usr/lib" -o "-L${libdir}" = "-L/usr/lib64" ]
	    then
		echo -lcss %SELECTOR_ENABLED_LDFLAGS%
	    else
		echo -L${libdir} -lcss %SELECTOR_ENABLED_LDFLAGS%
	    fi
	else
	    echo -L${libdir} -lcss %SELECTOR_ENABLED_LDFLAGS%
	fi
       	;;

    *)
	usage
	exit 1
	;;
    esac
    shift
done

exit 0
