
cwd=$(pwd)


tools=$HOME/tools
mkdir -p $tools

libs=$tools/libs
mkdir -p $libs

rm -f $tools/sw
ln -s $cwd/sw $tools/sw

for d in libs/*; do
   [ -d "$d" ] || continue
   bd=$(basename $d)
   libdir_lang=$libs/$bd
   mkdir -p $libdir_lang
   for dd in $d/*; do
     bdd=$(basename $dd)
     p=$libdir_lang/$bdd
     rm -f $p
     ln -s $cwd/$dd $p
   done
done

