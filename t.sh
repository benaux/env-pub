

nnn=".blalaname.dec.txt"


echo nnnname $nnn

echo ""

doppelprozent=${nnn%%.*}
echo dp doppelprozent $doppelprozent

prozent=${nnn%.*}
echo p prozent $prozent

doppelkreuz=${nnn##*.}
echo dk  $doppelkreuz

kreuz=${nnn#*.}
echo k $kreuz
