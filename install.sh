

input="$1"

die () { echo $@ 1>&2; exit 1 ; }

install_env=install-env.sh
install_decimals=install-decimals.sh
install_security=install-security.sh

#[ -f "$install_usrdirs_script" ] || die "Err: script $install_usrdir_script not available"
[ -f "$install_env" ] || die "Err: script $install_env not available"
[ -f "$install_decimals" ] || die "Err: script $install_decimals not available"
[ -f "$install_security" ] || die "Err: script $install_security not available"


sh "$install_env"

sh "$install_decimals"

sh "$install_security"

