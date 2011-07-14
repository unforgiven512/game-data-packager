#!/bin/sh

. lib/game-data-packager-shared

echo "foo" > out/foo
echo "bar" > out/bar
echo "baz" > out/baz

foosum=`md5sum out/foo | cut -d' ' -f1`
barsum=`md5sum out/bar | cut -d' ' -f1`

verify_md5sum_alternatives out/foo $foosum,$barsum
verify_md5sum_alternatives out/bar $foosum,$barsum
if ( verify_md5sum_alternatives out/baz $foosum,$barsum ); then
	die "out/baz should have failed the md5sum check!"
else
	echo "^ don't worry, that was meant to fail the md5sum check"
fi
