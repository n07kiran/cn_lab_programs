BEGIN{Num_of_pkts=0;}
{
if ($1 == "r" && $3 == "_1_" && $4 == "AGT" && $7 == "tcp")
{
Num_of_pkts = Num_of_pkts + $8;
}
}
END{
Throughput = Num_of_pkts * 8 / $2 /1000000;
printf("\n\n\tThroughput = %fbpms\n\n\n",Throughput);
}