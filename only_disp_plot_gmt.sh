#!/bin/bash 

main_dir=/media/monumoy/DATA/MONUMOY_WORK/Inversion/data_invert
#input_sob=${main_dir}/dot_d_file
#input_vel=${main_dir}/input-vel/vsv_data_all_node
#input_dsp=${main_dir}/input-vel/LQ-input_disp_all_error
#out_dir=${main_dir}/input-vel/LQ_Vsv_Synth_dsp
#script=/media/monumoy/CODE/SCRIPTS/Inversion/scripts_invert/Monu_scripts
#gmt_resources=/media/monumoy/CODE/packages/gmt_resources

#for Sdisp in 70.36_29.84_LQ_Vsv_Synth.dsp  73.15_25.74_LQ_Vsv_Synth.dsp  85.82_27.90_LQ_Vsv_Synth.dsp  75.17_19.42_LQ_Vsv_Synth.dsp  92.81_25.69_LQ_Vsv_Synth.dsp 85.10_33.60_LQ_Vsv_Synth.dsp
#do

file=MFA_2011165000834_II_ABKT.BHT

echo "---------------Working on file : $file -----------------"
#lon=`echo $Sdisp | awk -F_ '{print $1}'`
#lat=`echo $Sdisp | awk -F_ '{print $2}'`
#name=`echo $filehf | awk -F_ '{print $4}' | awk -F. '{print $1}'`
#out=${lon}_${lat}_disp_plot_Sdisp_Odisp_LQ.ps
out=${file}_disp_plot.ps

#-------------------------------------
## Plotting the dispersion 
#-------------------------------------
echo "Plotting Dispersion Curve"
gmt set PS_MEDIA A4 MAP_FRAME_TYPE plain MAP_FRAME_WIDTH 0.15c
gmt set FONT_ANNOT 14
gmt set FONT_LABEL 14
proj1="-JX10i/7i"
bounds1="-R5/125/2.5/5"
#outdisp=${lon}_${lat}_disp.out

gmt psbasemap -K ${bounds1} ${proj1} -BWSen -Bxa10f10+l"Period in seconds" -Bya1f0.5+l"Group velocity (km/s)" -V > ${out}

#cat minter_${file}.0.pole | awk '{print $1, $2, $3}' | gmt psxy -K -O ${proj1} -Ss0.25c -Gblue  -Ey/0.5,blue ${bounds1} >> ${out}
cat minter_${file}s.0.pole | awk '{print $1, $2, $3}' | gmt psxy -K -O ${proj1} -Sc0.25c -Gred -W0.3p,black -Ey/0.5,red ${bounds1} >> ${out}

### Plotting synthetic and obs data
#cat ${input_dsp}/LQ_input_${lat}_${lon} | awk '{print $6, $7}' | gmt psxy -K -O -JX -R -W1,black   >> ${out}\
#cat ${input_dsp}/LQ_input_${lat}_${lon} | awk '{print $6, $7 - $8, $7 + $8}' > temp1
#cat ${Sdisp} | awk '{print $7}' > temp2
#paste temp1 temp2 > temp
#cat temp
#cat temp | awk '{if($4<$2) print $1, $4}' > blue
#cat temp | awk '{if($4>$3) print $1, $4}' > red 
#cat temp | awk '{if($4>=$2 && $4<=$3) print $1, $4}' > green 
#cat ${Sdisp} | awk '{print $6, $7}' | gmt psxy -K -O -JX -Sc0.2c -Gblue  -R    >> ${out}
#gmt psxy blue -K -O -JX -Sc0.25c -Gblue  -R  >> ${out}
#gmt psxy red -K -O -JX -Sc0.25c -Gred  -R  >> ${out}
#gmt psxy green -K -O -JX -Sc0.25c -Ggreen  -R  >> ${out}


#cat ${rootss}_LQ_U_SYN.dsp | awk '{if($1==1) print }' | awk '{print $3, $6}' | gmt psxy -K -O -JX -W3,205/173/0  -R    >> ${out}
#cat ${rootss}_LQ_U_SYN.dsp | grep " 2 " | awk 'NR>1{print $3, $6}' | gmt psxy -K -O -JX -W3,green  -R    >> ${out}

gmt pslegend ${proj1} ${bounds1} -O -K -D8i/0.4i+w1.98i/.7i+jBL -F+ggrey  >> ${out} << END
S 0.1i c 0.25 red 0.3p,black 0.3i Observe LQ
S 0.1i - 0.25 red 1.4p,red 0.3i LQ Uncertainity
#S 0.1i c 0.25 blue 1p,blue 0.3i Underestimate
#S 0.1i c 0.25 red 1p,red 0.3i Overestimate
#S 0.1i c 0.25 green 1p,green 0.3i Within Uncertainity
#S 0.1i v 0.2 205/173/0 1p,205/173/0 0.3i SYN LQ (mode=1) 
#S 0.1i v 0.2 green 1p,green 0.3i SYN LQ (mode=2) 
END



gmt psxy -JX -R -O < /dev/null >> ${out}
gv $out
ps2eps -f -R=+ $out

done


