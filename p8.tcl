set ns [new Simulator] 

set namfile [open p8.nam w]  
$ns namtrace-all $namfile 

set tracefile [open p8.tr w]  
$ns trace-all $tracefile

proc finish {} {  
    global ns namfile tracefile
    $ns flush-trace  
    close $namfile
    close $tracefile  
    puts "running nam..."  
    exec nam p8.nam &  
    exit 0  
}  


set n0 [$ns node]  
set n1 [$ns node]  

$ns duplex-link $n0 $n1 0.2Mb 200ms DropTail  
$ns duplex-link-op $n0 $n1 orient right  
$ns queue-limit $n0 $n1 10  


Agent/TCP set nam_tracevar_ true

set tcp [new Agent/TCP]
$tcp set windowInit_ 4
$tcp set maxcwnd_ 4
$ns attach-agent $n0 $tcp  

set sink [new Agent/TCPSink]  
$ns attach-agent $n1 $sink  
$ns connect $tcp $sink  

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns add-agent-trace $tcp tcp
$ns monitor-agent-trace $tcp 
$tcp tracevar cwnd_

$ns at 0.0 "$n0 label Sender"  
$ns at 0.0 "$n1 label Receiver"  
$ns at 0.1 "$ftp start"  
$ns at 3.0 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n1 $sink"  
$ns at 3.5 "finish" 
$ns run