
## process model data
#--------------------------------Settings Start-------------------------------------------------------------
casename=(FAMIPC5_f09f09_CIESM_LS4P_climo_2003.05)

copy_to_datadir=false
ens_mean=false
June_minus_May=true

int_ens_id=1
end_ens_id=8
num_ens=8

int_ens_id_4d=`printf %04d $int_ens_id`
end_ens_id_4d=`printf %04d $end_ens_id`

int_month=5
end_month=6

year=2003

vars=(gw,PRECT,TREFHT)

echo $vars
#--------------------------------Settings End-------------------------------------------------------------

ncase=${#casename[@]}

#for id in `seq 0 $[$num_ens-1]`
for id in `seq $int_ends_id $end_ens_id`
do
id_4d=`printf %04d $id`

casedir=/home/lyl/WORK4/cesm1_2_1/archive/${casename}_${id_4d}/atm/hist/
echo $casedir

workdir=/home/share3/lyl/work3/qinyi/data/LS4P/
if [ ! -d "$workdir" ]; then
mkdir $workdir
fi

outdir=/home/share3/lyl/work3/qinyi/mid-data/LS4P/
if [ ! -d "$outdir" ]; then
mkdir $outdir
fi

#----------------------------------------------------------
echo $workdir
cd $workdir

if [ ${copy_to_datadir} == "true" ] ; then
echo "copy to data dir first.."
	cp ${casedir}/* $workdir	
fi

done # for id in...

cd $workdir
if [ ${ens_mean} == "true" ] ; then
echo "ensemble mean starts..."

	for i in `seq $int_month $end_month`;
	do
	month=`printf %02d $i`
	echo $month
	
	# ensemble mean for each month
	ncra -O  -v $vars $workdir/*.cam.h0.${year}-${month}.nc $workdir/${casename[icase]}.${year}.ensemble_mean-${month}.nc

	done  # i
fi

if [ ${June_minus_May} == "true" ] ; then
echo "June minus May starts..."
	ncdiff $workdir/${casename[icase]}.${year}.ensemble_mean-06.nc $workdir/${casename[icase]}.${year}.ensemble_mean-05.nc $workdir/${casename[icase]}.${year}.ensemble_mean.June_minus_May.nc
	ncks -d 
fi

echo "Well done!"
