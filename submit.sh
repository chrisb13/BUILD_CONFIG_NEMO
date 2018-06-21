#!/bin/bash
#################################################################################
# N. Jourdain, IGE-CNRS, Feb. 2017
#
# purpose: used to run an executable in a batch job
#
#################################################################################

rm -f tmptxp.sh

if [ ! -n "$1" ]; then
  echo "Usage: `basename $0` file_to_execute  [hh] [mem]                    "
  echo "       hh is the walltime in hours, with two digits (default is 02) "
  echo "       mem is the required memory in GB (default is 5GB)            "
  echo "       ex.: ./submit.sh extract_bathy_meter                         "
  echo "            ./submit.sh extract_bathy_meter 05 10                   "
  exit
fi

if [ $# -eq 1 ]; then
  walltime="02:00:00"
  mem=5
elif [ $# -eq 2 ]; then
  walltime="$2:00:00"
  mem=5
elif [ $# -eq 3 ]; then
  walltime="$2:00:00"
  mem=$3
elif [ $# -gt 3 ]; then
  echo "Usage: `basename $0` file_to_execute [hh]"
  echo "       (hh is the walltime in hours, with two digits, default is 02)"
  echo "       ex.: ./submit.sh extract_bathy_meter 05                      "
  exit
fi

echo "walltime=$walltime"
echo "mem=${mem}Gb"

#=====
if [ `hostname | cut -d"." -f2` == "occigen" ]; then

echo "host is occigen"
cat > tmptxp.sh << EOF
#!/bin/bash
#SBATCH -C HSW24
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --threads-per-core=1
#SBATCH -J submit_${1}
#SBATCH -e submit_${1}.e%j
#SBATCH -o submit_${1}.o%j
#SBATCH --mem=${mem}GB
#SBATCH --time=${walltime}
EOF

elif [ `hostname | cut -c 1-3` == "ada" ]; then

echo "host is adapp"
cat > tmptxp.sh << EOF
# @ job_type = serial
# @ requirements = (Feature == "prepost")
# @ wall_clock_limit = ${walltime}
# @ job_name = submit_${1}
# @ output = \$(job_name).\$(jobid)
# @ error = \$(job_name).\$(jobid)
# @ wall_clock_limit = ${walltime}
# @ as_limit = ${mem}.0gb
# @ queue
EOF

#ARCHER interactive hostname is something like 'eslogin001'
elif [ `hostname | cut -c 1-7` == "eslogin" ]; then

echo "host is ARCHER"
echo "Warning: Memory option is unsupported on ARCHER"
cat > tmptxp.sh << EOF #allows walltime sub'
#!/bin/bash --login
#PBS -l select=serial=true:ncpus=1
#PBS -l walltime=${walltime}
EOF

cat >> tmptxp.sh << 'EOF' #appends to file using 'EOF' to keep variables.
#PBS -A n02-FISSA
#CB note: doesn't look like you can use more than 64 gb memory
#see: http://www.archer.ac.uk/documentation/user-guide/
#these were never used b/c the pp nodes have different processors so the fortran programs didn't work

# Make sure any symbolic links are resolved to absolute path
echo $PBS_O_WORKDIR
export PBS_O_WORKDIR=$(readlink -f $PBS_O_WORKDIR)

# Change to the directory that the job was submitted from
cd $PBS_O_WORKDIR

EOF

else

echo "default host"
echo '#!/bin/bash' > tmptxp.sh
echo " "
echo "WARNING: You may need to add a specific header in submit.sh if `hostname` enables batch jobs"
echo " "

fi
#=====

echo "./$1" >> tmptxp.sh

chmod +x tmptxp.sh

echo "Launching $1 on  `hostname`"

if [ `hostname | cut -d"." -f2` == "occigen" ]; then
  sbatch ./tmptxp.sh
elif [ `hostname | cut -c 1-3` == "ada" ]; then
  llsubmit ./tmptxp.sh
elif [ `hostname | cut -c 1-7` == "eslogin" ]; then
  qsub ./tmptxp.sh
else
  ./tmptxp.sh
fi

rm -f tmptxp.sh
