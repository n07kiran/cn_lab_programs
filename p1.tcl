set ns [new Simulator]

set tracefile [open p1.tr w]
$ns trace-all $tracefile

set namfile [open p1.nam w]
$ns namtrace-all $namfile

proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exec nam p1.nam &
	exec echo "No of packets dropped : " &
	exec grep -c ^d p1.tr &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail

$ns queue-limit $n0 $n1 5
$ns queue-limit $n1 $n2 5


set udp [new Agent/UDP]
set null [new Agent/Null]

$ns attach-agent $n0 $udp
$ns attach-agent $n2 $null

$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

$ns at 0.1 "$cbr start"
$ns at 5.0 "$cbr stop"
$ns at 5.5 "finish"
$ns run