set ns [ new Simulator ]

$ns color 1 blue

set namfile [ open p4.nam w ]
$ns namtrace-all $namfile

set tracefile [ open p4.tr w ]
$ns trace-all $tracefile 

set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]
set n3 [ $ns node ]
set n4 [ $ns node ]

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n2 $n3 10Mb 10ms DropTail
$ns duplex-link $n3 $n4 10Mb 10ms DropTail
$ns duplex-link $n4 $n0 10Mb 10ms DropTail

set udp [ new Agent/UDP ]
set null [new Agent/Null]

#$tcp set fid_ 1

$ns attach-agent $n0 $udp
$ns attach-agent $n3 $null

$ns connect $udp $null

set cbr [ new Application/Traffic/CBR ]
$cbr attach-agent $udp

proc finish {} {
     global ns namfile tracefile 
     $ns flush-trace 
     close $namfile
     close $tracefile 
     exec nam p4.nam &
     exit 0
     }

$ns at 0.1 "$cbr start"
$ns at 1.0 "$cbr stop"
$ns at 1.5 "finish"
$ns run