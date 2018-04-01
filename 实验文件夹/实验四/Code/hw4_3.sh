#!bin/bash

function Help()
{
	echo Usage: 
	echo "bash $0 t : Access the source host TOP 100 and corresponding total number of occurrences respectively."
	echo "bash $0 i : Access source host TOP 100 IP and corresponding total number of occurrences."
	echo "bash $0 u : The most frequently accessed URL TOP 100."  
	echo "bash $0 s : The number of different response status codes and corresponding percentages."  
	echo "bash $0 d : The TOP 10 URL and the total number of corresponding occurrences of different 4XX status codes are respectively calculated."  
	echo "bash $0 a [url] : A given URL outputs the TOP 100 access source host."  
	exit 1
}
if [ $# > 2 ];then
	if [ $# == 1 ];then
		if [ $1 == "t" ];then
			sed -e '1d' web_log.tsv | awk -F '\t' '{Number[$1]++} END {for(i in Number){print i,Number[i] }}' |  sort -nr -k2 | head -n 100

		elif [ $1 == "i" ];then
			sed -e '1d' web_log.tsv | awk -F '\t' '{Number[$1]++} END {for(i in Number){print i,Number[i] }}' | awk '{ if($1~/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]/){print} }' | sort -nr -k2 | head -n 100

		elif [ $1 == "u" ];then
			sed -e '1d' web_log.tsv | awk -F '\t' '{Number[$5]++} END {for(i in Number){print i,Number[i] }}' |  sort -nr -k2 | head -n 100

		elif [ $1 == "s" ];then
			sed -e '1d' web_log.tsv | awk -F '\t' '{Number[$6]++} END {for(i in Number){print i,Number[i] }}' |  sort -nr -k2 | head -n 100
			sed -e '1d' web_log.tsv | awk -F '\t' '{Number[$6]++} END {for(i in Number){print i,Number[i] }}' |  sort -nr -k2 | awk '{arr[$1]=$2;sum+=$2} END {for (j in arr) print j,arr[j]/sum*100}'

		elif [ $1 == "d" ];then
			sed -e '1d' web_log.tsv | awk -F '\t' ' {if($6~/^403/) {Number[$6":"$1]++}} END {for(i in Number){print i,Number[i] }}' | sort -nr -k2 | head -n 10
			sed -e '1d' web_log.tsv | awk -F '\t' ' {if($6~/^404/) {Number[$6":"$1]++}} END {for(i in Number){print i,Number[i] }}' | sort -nr -k2 | head -n 10

		else
			Help
		fi

	elif [ $# == 2 -a $1 == "a" ];then
		sed -e '1d' web_log.tsv | awk -F '\t' '{if($5=="'${2}'") {Number[$1]++}} END {for(i in Number) {print i,Number[i]} }' | sort -nr -k2 | head -n 100

	else
		Help     
	fi

else
	Help
fi
