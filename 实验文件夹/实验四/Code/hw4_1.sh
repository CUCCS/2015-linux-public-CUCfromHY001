#!bin/bash


function Help()
{
    echo Use guide: 
    echo "    bash  $0 q [quality parameter] [source.jpg] [destination.jpg] : Image quality compression for jpeg format images"
    echo "    bash  $0 e [%|(size)x(size)] [source.jpg|png] [destination.jpg|png] : compress image while maintaining the orginal height and width"
    echo "    bash  $0 m [watermark] [source.jpg] [destination.jpg] : embed watermark(only english)"  
    echo "    bash  $0 r [pattern] [replacement] : batch rename file"  
    echo "    bash  $0 t [source.png] [destination.jpg] : transform png format images to jpeg format images(no filename extension!)"  
    exit 1
}

function Main()
{
    case $1 in
        0) if [ $# == 4 ];then
		if [ ! -f "$3" ];then
			    echo "no source file"
		else
			if [ `file --mime-type -b $3` == "image/jpeg" ];then
				$(convert -quality $2 $3 $4)
				if [ $? == 1 ];then
			            echo "Failed!"
				    exit 1
				else
				    echo "Success!"
				    exit 0
				fi
			else
				echo "Type of the image is Wrong!"
				exit 1
			fi
		fi
	   else
		Help
	   fi

	   ;;
	1) if [ $# == 4 ];then
		if [ ! -f "$3" ];then
			echo "no source file"
		else
			if [ `file --mime-type -b $3` == "image/jpeg" -o `file --mime-type -b $3` == "image/png" ];then
				$(convert $3 -resize $2 $4)
 	                        if [ $? == 1 ];then
			            echo "Failed!"
				    exit 1
				else
				    echo "Success!"
				    exit 0
				fi
			else
				echo "Type of the image is Wrong!"
				exit 1
			fi
		fi
	   else
		Help
	   fi

	   ;;
         2) if [ $# == 4 ];then
		 if [ ! -f "$3" ];then
			 echo "no source file"
	         else
			 $(convert $3 -gravity southeast -fill black -pointsize 16 -draw "text 5,5 '$2'" $4)
                         if [ $? == 1 ];then
		             echo "Failed!"
		             exit 1
		         else
		             echo "Success!"
	                     exit 0
		         fi
		 fi
           else
		Help
	   fi

	   ;;
         3) if [ $# == 3 ];then
		$(rename  s'/'$2'/'$3'/' *)
                if [ $? == 1 ];then
	             echo "Failed!"
		     exit 1
		else
		     echo "Success!"
	             exit 0
		fi
           else
		Help
	   fi


	  ;;
         4) if [ $# == 3 ];then

		 if [ ! -f $2.png ];then
		     echo "no source file"
		     exit 1
	         else
		     if [ `file --mime-type -b $2.png` == "image/png" ];then
			 $(convert $2.png $3.jpg)
			 if [ $? == 1 ];then
				 echo "Failed!"
				 exit 1
			 else
				 echo "Success!"
				 exit 0
			 fi

		     else
			 echo "Type of the image is wrong!"
			 exit 1
		     fi
	         fi
            else
		    Help
            fi
            ;;
 
    esac	   
}
function Parameter()
{
    para=("q" "e" "m" "r" "t")
    number=0
    if [ $# -gt 0 ];then
        if [ $1 == "-h" ];then
            Help
        fi
        for P in ${para[@]};do
            if [ $P == "$1" ];then
                Main $number $2 $3 $4
                exit 0
            fi
            number=$(($number + 1))
        done
    fi
    Help
}

Parameter $1 $2 $3 $4
