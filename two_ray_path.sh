#!/bin/bash

################################################################################
#
#
################################################################################




echo "Put the name of the text file below"
read file

data_file=${file}


echo "Arrenging raypaths for plot"
#use datalatlong.sh
#<<C
rm -f ray_path.txt
cat $data_file | while read line
do
evla=`echo $line | awk '{print $2}'`
evlo=`echo $line | awk '{print $3}'`
stla=`echo $line | awk '{print $4}'`
stlo=`echo $line | awk '{print $5}'`
#make ray path file
echo $evlo $evla >> ray_path.txt
echo $stlo $stla >> ray_path.txt
echo ">" >> ray_path.txt
done
#C


########## overriding gmt defaults for paper media ####################
####### plotting a map and both the dispersion curves using gmt########
gmt set PS_MEDIA A3 MAP_FRAME_TYPE plain MAP_FRAME_WIDTH 0.15c
#gmt gmtset MAP_FRAME_TYPE plain 
gmt set FONT_ANNOT_PRIMARY 12p,Helvetica
gmt set MAP_FRAME_PEN 1p

##### making the map ######################
# Mercator projecton
proj="-JM20"
# Equal area projection
#proj="-JB44/130/7/61/8i"
bounds="-R45/110/-15/45"
miscB="-Ba5f2.5 -BWSen"
misc="-P"
pview="-p115/30"
out=$file
echo "output file is ${out}.ps"


################## cpt and grid files here #######################################
reso_path=/home/sayandeep/Downloads/Sac
gridfile=$reso_path/etopo2.grd
cptfile=$reso_path/india_new.cpt
##################################################################################

gmt grdgradient ${gridfile} -Nt1 -A45 -Gglobal.grd

gmt grdimage ${gridfile}  -Iglobal.grd -C${cptfile} -V $bounds  $proj  -K > ${out}.ps

#gmt pscoast $proj  $bounds -W1  -Di -A500 $miscB  -N1/0.5 -K  -O >> $out.ps

# writing the ray coverage input file
gmt psxy ray_path.txt -R -K -O $proj -W0.05 -G0/0/0 >> ${out}.ps

# location of event
cat $data_file | awk '{print $3, $2}' | gmt psxy -R -K -O $proj -Sc0.15c -G255/0/0 -W0 >> ${out}.ps

# location of station
cat $data_file  | awk '{print $5, $4}' | gmt psxy -K -O $proj -R -St0.3c -G0/0/255 -W0 >> ${out}.ps

#Legend for the symbols used
gmt pslegend -R -J -O -K -F+g255/255/255+p0.8 -Dx18.5/18.5/1.1i/0.6i/TC -C0.1i/0.1i -Vn << EOF >> ${out}.ps
S 0.4c t 0.40 0/0/255 0.7p 0.3i Stations
S 0.4c c 0.20 255/0/0 0.7p 0.3i Events
EOF

gmt psxy ${reso_path}/kashmir.dat $proj $bounds -W1,white -K -O >> ${out}.ps 
gmt pscoast $proj  $bounds $miscB -W1,white  -Di -A1500 -Na/1,white -K  -O -V >> ${out}.ps

################################ end of plot #####################################
gmt psxy ${proj} ${bounds} -O < /dev/null >> ${out}.ps

### save as .png file
gmt psconvert ${out}.ps -A0.2c+s10c -P -Tg
# plotting the map
gv ${out}.ps
#ps2pdf ${out}.ps ${out}.pdf
ps2eps -f -R=+ ${out}.ps
# removing gmt defaults
rm -f ./.gmtdefaults4 ./.gmtcommands4

###################################################################

#cleaning up 
rm -f INDIA_temp.grd gmt.conf gmt.history global.grd
# end
cd -





