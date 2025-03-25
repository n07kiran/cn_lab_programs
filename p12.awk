BEGIN {Total_no_of_pkts=0;}
{
if($1 == "r")
{
Total_no_of_pkts = Total_no_of_pkts + $6;
printf("%f %d\n",$2,Total_no_of_pkts) >> "cdma.xg"
}
}
END{}
