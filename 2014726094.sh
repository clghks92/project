#!/bin/bash
#include <stdio.h>


function file_name()
{
 j=2
 tput cup 1 1
 echo "[31m.."

 for filename in `ls | sort` ; 
 do 
   if ["`stat -c %F $filename`" = "directory"]
     then 
        if [$j  -ge 22]; 
            then 
               break
        fi 
        tput cup $j 1
   echo -n "[34m"
   echo "$filename" | cut -c 1-10
   j = `expr $j + 1`
   fi 
 done
 for filename in `ls` ;
 do
   if ["`stat -c %F $filename | cut -c 1-6`" ="file"]
     then 
        if [$j -ge 22];
          then 
              break
        fi
   tput cup $j 1
   echo -n "[0m"
   echo "$filename" | cut -c 1-10
   j = `expr $j + 1`
   fi
 done
 for filename in `ls`;
 do 
   if ["`stat -c %F $filename |cut -c 1-3`" != "directory"] && ["`stat -c %F $filename |cut -c 1-3`" != "file"];  
     then 
        if [$j -ge 22]; 
          then
             break

        fi
   tput cup $j 1
   echo "$filename" | cut -c 1-10
   echo -n "[32m"
   j = `expr $j + 1`
   fi
 done
 echo -n "[0m"
}

function move()
{
 read -n 1 key
  if [key = [A]
   then 
  elif [key = [B]
   then
}




function line()
{
 echo "====================================================== 2014726094 =================================================================" echo "========================================================= list ===================================================================="
 for i in {1..36}
 do 
  echo "|"
  tput cup $i 105
  echo "|"
 done
 current_directory=$(pwd)
 cd ..
 file_name
 move
 for i in {1..27}
  do
   tput cup $i 20
   echo "|"
  done
  cd $current_directory
  tput cup 28 1
  echo "====================================================== information ===============================================================" 
  tput cup 35 1
  echo "========================================================== Total ================================================================="
  tput cup 37 0
  echo "=========================================================== end =================================================================="
}



















































