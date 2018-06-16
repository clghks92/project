#!/bin/bash


outline(){
clear
echo "=============================================== 2015726080 Daewook Choi ================================================"
echo "========================================================= List ========================================================="

i=0

while [ "$i" -le 27 ]
do
echo "|                            |                                              |                                          |"

i=`expr $i + 1`
done

echo "====================================================== Information ====================================================="
echo "|file name : "
echo "|"
echo "|file size : "
echo "|creation time : "
echo "|permission : "
echo "|absolute path : "
echo "========================================================= Total ========================================================"
echo "| "
echo "========================================================== END ========================================================="
}

list(){
declare -i i=1
tput cup 2 1

if [ $x = 2 ]
then
	tput setaf 4; tput rev; echo ".."; tput sgr0
else
	tput setaf 4; echo ".."; tput sgr0
fi
index[0]=".."

for A in * # 디렉토리 먼저 배열.
do
	if [ $i -ge 28 ]
	then
		break
	fi

	if [ -d $A ]
	then
		tput cup `expr $i + 2` 1; tput setaf 4
		if [ $i -eq `expr $x - 2` ]
		then
			tput rev; echo "$A" | cut -b -28; tput sgr0
		else
			echo "$A" | cut -b -28
		fi
		index[$i]="$A"
		i=`expr $i + 1`
		tput sgr0
	fi
done

for A in * # 디렉토리를 제외한 파일들.
do
	if [ $i -ge 28 ]
	then
		break
	fi

	if [ -f $A ]
	then
		gz=`ls $A | grep '.gz$'`
		zip=`ls $A | grep '.zip$'`
		tput cup `expr $i + 2` 1

		if [ -x $A ] # execute file
		then
			tput setaf 2;
			if [ $i -eq `expr $x - 2` ]
			then
				tput rev; echo "$A" | cut -b -28; tput sgr0
			else
				echo "$A" | cut -b -28
			fi
			tput sgr0
		elif [ $zip ] || [ $gz ] # if .zip or .gz
		then
			tput setaf 1
			if [ $i -eq `expr $x - 2` ]
			then
				tput rev; echo "$A" | cut -b -28; tput sgr0
			else
				echo "$A" | cut -b -28
			fi
			tput sgr0
		else # others"
			if [ $i -eq `expr $x - 2` ]
				then
				tput rev; echo "$A" | cut -b -28; tput sgr0
			else
				echo "$A" | cut -b -28
			fi
		fi
		index[$i]="$A"
		i=`expr $i + 1`
	fi
done
}

dir_inform(){
total=`ls | wc -l`
dir_num=`ls -F | grep '/$' | wc -l`
gz_num=`ls | grep '.gz$' | wc -l`
zip_num=`ls | grep '.zip$' | wc -l`
exe_num=`ls -F | grep '*$' | wc -l`
S_num=`expr $gz_num + $zip_num + $exe_num`
file_num=`expr $total - $dir_num - $S_num`
size=`du -bs | cut -f 1`
tput cup 38 25
echo " $total total $dir_num directory $file_num file $S_num Sfile $size byte"
}

detail_inform(){
i=`expr $x - 2`
gz=`ls ${index[$i]} | grep '.gz$'`
zip=`ls ${index[$i]} | grep '.zip$'`

tput cup 31 13
echo "${index[$i]}" | cut -b -106
tput cup 32 1
if [ -d ${index[$i]} ]
then
	echo -e "\033[34m"file type : directory"\033[0m"
elif [ -x ${index[$i]} ]
then
	echo -e "\033[32m"file type : execute file"\033[0m"
elif [ $zip ] || [ $gz ]
then
	tput setaf 1; echo "file type : compressed file"; tput sgr0
else
	echo "file type : regular file"
fi
tput cup 33 13
echo "`stat -c %s ${index[$i]}`"
tput cup 34 17
echo "`stat -c %z ${index[$i]}`"
tput cup 35 14
echo "`stat -c %a ${index[$i]}`"
tput cup 36 17
echo "$PWD/${index[$i]}" | cut -b -102
}

file_content(){
i=`expr $x - 2`
line=`cat ${index[$i]} | wc -l`
if [ $line -ge 29 ]
then
	a=1
	while [ $a -le 27 ]
	do
		b=`expr 30 - $a`
		cat_file=`cat -T ${index[$i]} | tail -$b | head -1`
		tput cup `expr $a + 1` 30
		echo "$a  $cat_file" | cut -b -46
		a=`expr $a + 1`
	done
	tput cup 29 30
	echo "..."
	tput sgr0
else
	a=1
	while [ $a -le $line ]
	do
		b=`expr $line - $a + 1`
		cat_file=`cat -T ${index[$i]} | tail -$b | head -1`
		tput cup `expr $a + 1` 30
		echo "$a  $cat_file" | cut -b -46
		a=`expr $a + 1`
	done
	tput sgr0
fi
}

cursor(){
IFS= # distinguish " " "\t" from "\n"

while [ 1 ]
do
	read -sn 1 key
	if [ "$key" = '' ]
	then
		read -sn 1 key
		read -sn 1 key
		if [ "$key" = 'A' ]
		then
			if [ $x -ge 3 ]
			then
				x=`expr $x - 1`
				base
			fi

		elif [ "$key" = 'B' ]
		then
			if [ $x -le 28 ] && [ $x -le `expr $total + 1` ]
			then
				x=`expr $x + 1`
				base
			fi 
		fi
	elif [ "$key" = "" ]
	then
		if [ -d ${index[`expr $x - 2`]} ]
		then
			cd ${index[`expr $x - 2`]}
			x=2
			base
		elif [ -f ${index[`expr $x - 2`]} ]
		then
			file_content
		fi
	else
		continue
	fi
done
}

base(){
outline
list
dir_inform
detail_inform
}

x=2
base
cursor
