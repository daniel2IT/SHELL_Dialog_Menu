ex=0
while [ $ex -eq 0 ]
do
dialog --title "Sarasas" --menu "Pasirinkite punkta:" 0 0 5 \
Naujo_iraso_ivedimas "vardas,pavarde,tel.nr,el.pastas" \
Iraso_paieska "Pagal varda" \
Saraso_perziura "Viso" \
Iraso_salinimas "Pagal eilutes nr.(ID)" \
Iseiti "Iseiti is meniu" 2>zmoness.txt
kint=$?
zms=$(cat zmoness.txt)
case $kint in
0) case $zms in
Naujo_iraso_ivedimas) dialog --inputbox \
"Iveskite varda,pav,tel nr,el.pasta" 0 0 2>vardas.txt
vpte=$?
case $vpte in
0) if [ -s vardas.txt ]
then
cat vardas.txt >>telk.txt
echo "" >>telk.txt
fi;;
1);;
255);;
esac
;;
Iraso_paieska) dialog --inputbox "Iveskite ieskomo zmogaus varda:" 0 0 2>iesk.txt
isk=$?
case $isk in
0) vard=$(cat iesk.txt)
grep "$vard" telk.txt > irasas.txt
if [ -s irasas.txt ]
then
dialog --msgbox "Irasas rastas: $(cat irasas.txt)" 15 20
else
dialog --msgbox "Irasas nerastas" 5 20
fi;;
1);;
255) ;;
esac;;
Saraso_perziura)
if [ -s telk.txt ]
then
 dialog --msgbox "Kontaktu sarasas: $(cat -n telk.txt)" 100 100
else
dialog --msgbox "Sarasas tuscias" 0 0
fi;;
   Iraso_salinimas)
 if [ -s telk.txt ]
then
dialog --inputbox "Iveskite eil nr. kontakto, kad ji pasalinti : " 0 0 2>salin.txt
sal=$?
case $sal in
0) sali=$(cat salin.txt)
if [ -s salin.txt ]
then
dialog --yesno \
"Ar tikrai norite salinti $(head -n "$sali" telk.txt | tail -n 1) ?" 0 0
salin=$?
case $salin in
0)sed -i "$sali"'d' telk.txt;;
1);;
255);;
esac
else
dialog --msgbox "Nieko neivedete" 0 0
fi;;
1);;
255);;
esac
else
dialog --msgbox "Sarasas tuscias" 0 0
fi;;
Iseiti) ex=$(expr $ex + 1) ;;
esac;;
1)exit;;
255)exit;;
esac

rm -f salin.txt
rm -f vardas.txt
rm -f iesk.txt
rm -f irasas.txt
rm -f zmoness.txt
done
