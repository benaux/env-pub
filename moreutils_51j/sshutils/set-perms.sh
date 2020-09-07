

dir=$HOME/.ssh

chmod 0700 $dir
chmod 0600 $dir/*

[ -f "$dir/authorized_keys" ] && chmod 644 $dir/authorized_keys
[ -f "$dir/known_hosts"  ] && chmod 644 $dir/known_hosts
[ -f "$dir/config" ] && chmod 644 $dir/config

for f in $dir/*.pub ; do
  pf=${f%.*}
	chmod 644 $f
	chmod 600 $pf
done
