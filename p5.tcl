set ns [ new Simulator ]

set namfile [ open p5.nam w ]
$ns namtrace-all $namfile

set tracefile [ open p5.tr w ]
$ns trace-all $tracefile

set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]
set n3 [ $ns node ]
set n4 [ $ns node ]
set n5 [ $ns node ]

$n0 shape square

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n0 $n3 10Mb 10ms DropTail
$ns duplex-link $n0 $n4 10Mb 10ms DropTail
$ns duplex-link $n0 $n5 10Mb 10ms DropTail

set udp [ new Agent/UDP ]
set null [ new Agent/Null ]

#$tcp set fid_ 1

$ns attach-agent $n1 $udp
$ns attach-agent $n5 $null
$ns connect $udp $null

set cbr [ new Application/Traffic/CBR ]
$cbr attach-agent $udp

proc finish {} {
	global ns namfile tracefile
	$ns flush-trace
        close $tracefile
	close $namfile
	exec nam p5.nam &
	exit 0
}

$ns at 0.1 "$cbr start"
$ns at 1.0 "$cbr stop"
$ns at 1.5 "finish"
$ns run