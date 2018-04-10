#!bin/bash

function Help()
{
    echo "Usage:"
    echo "bash $0 l : low 20-year-old"
    echo "bash $0 b : between 20 and 30 years old"  
    echo "bash $0 a : above 30-year-old"  
    echo "bash $0 p : the number and position of players"  
    echo "bash $0 n : the longest/shortest name"
    echo "bash $0 x : the oldest/yongest"   
    exit 1
}

AllPlayerNumber=$( sed -e '1d' worldcupplayerinfo.tsv | wc -l )


if [ $1 == "l" ];then
        Numberl=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if($6<20) print $9}' | wc -l)
	echo "Then number of players who low 20-year-old: " $Numberl
        MiddlePercent=$(awk "BEGIN { pc=100*${Numberl}/${AllPlayerNumber}; print pc }")
        Percent=`echo "scale=2;$MiddlePercent/1" | bc`
        echo Percentage : $Percent%


elif [ $1 == "b" ];then
	Numberb=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if(($6>20 || $6==20) && ($6<30 || $6==30)) print $9}' | wc -l)
	echo "Then number of players who betweem 20 and 30 years old: " $Numberb
        MiddlePercent=$(awk "BEGIN { pc=100*${Numberb}/${AllPlayerNumber}; print pc }")
        Percent=`echo "scale=2;$MiddlePercent/1" | bc`
        echo Percentage : $Percent%


elif [ $1 == "a" ];then
	Numbera=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if($6>30) print $9}' | wc -l)
	echo "Then number of players who above 30-year-old: " $Numbera
        MiddlePercent=$(awk "BEGIN { pc=100*${Numbera}/${AllPlayerNumber}; print pc }")
        Percent=`echo "scale=2;$MiddlePercent/1" | bc`
        echo Percentage : $Percent%

elif [ $1 == "p" ];then 
	NumberG=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if( $5 == "Goalie" ) print $9}' | wc -l )
	NumberD=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if( $5 == "Defender" ) print $9}' | wc -l )
	NumberM=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if( $5 == "Midfielder" ) print $9}' | wc -l )
	NumberF=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if( $5 == "Forward" ) print $9}' | wc -l )

	MiddlePercentG=$(awk "BEGIN { pc=100*${NumberG}/${AllPlayerNumber}; print pc }")
	PercentG=`echo "scale=2;$MiddlePercentG/1" | bc`
	MiddlePercentD=$(awk "BEGIN { pc=100*${NumberD}/${AllPlayerNumber}; print pc }")
	PercentD=`echo "scale=2;$MiddlePercentD/1" | bc`
	MiddlePercentM=$(awk "BEGIN { pc=100*${NumberM}/${AllPlayerNumber}; print pc }")
	PercentM=`echo "scale=2;$MiddlePercentM/1" | bc`
	MiddlePercentF=$(awk "BEGIN { pc=100*${NumberF}/${AllPlayerNumber}; print pc }")
	PercentF=`echo "scale=2;$MiddlePercentF/1" | bc`

	echo "Number of Goalie    / Percent :" $NumberG / $PercentG%
	echo "Number of Defender  / Percent :" $NumberD / $PercentD%
	echo "Number of Midfielder/ Percent :" $NumberM / $PercentM%
	echo "Number of Forward   / Percent :" $NumberF / $PercentF%

elif [ $1 == "n" ];then
	longest=$(sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{print $9}' | awk ' NR==1{x = length($0)};	NR>=2 {if ( length($0) > x ) { x = length($0) } }END{ print x }')
	echo Longest Names:
	awk -F '\t' '{if ( length($9)=='$longest' ) print $9}' worldcupplayerinfo.tsv 
	
	shortest=$(sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{print $9}' | awk 'NR==1 {x=length($0)};NR>=2{if ( length($0) < x) {x = length($0) }} END{print x}' )
	echo Shortest Name:
        awk -F '\t' '{if ( length($9)=='$shortest' ) print $9}' worldcupplayerinfo.tsv 


elif [ $1 == "x" ];then
	oldest=$(sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' ' NR==1{old=$6};NR>=2{if($6>old){old =$6} } END{print old} '  )	
	echo "The oldest player(s) :"
	awk -F '\t' '{if ($6=='$oldest') print $9}' worldcupplayerinfo.tsv 
	echo "Oldest age is :"$oldest
        yongest=$(sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' ' NR==1{yong=$6};NR>=2{if($6<yong){yong =$6} } END{print yong} '  )	
	echo "The yongest player(s) :"
	awk -F '\t' '{if ($6=='$yongest') print $9}' worldcupplayerinfo.tsv 
	echo "Yongest age is :"$yongest


elif [ $1 == "h" ];then
	Help

else
	Help
fi



