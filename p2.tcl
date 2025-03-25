set ns [new Simulator]

set tracefile [open p2.tr w]
$ns trace-all $tracefile

set namfile [open p2.nam w]
$ns namtrace-all $namfile

proc finish { } {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exec echo "No of ping packets dropped : " &
	exec grep ^d p2.tr | cut -d " " -f 5 | grep -c "ping" &
	exec nam p2.nam &
	exit 0
}

Agent/Ping instproc recv {from rtt} {
	$self instvar node_
	puts "node [$node_ id] recieved ping message from node $from, rtt : $rtt ms"

}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 10Mb 1ms DropTail
$ns duplex-link $n1 $n2 10Mb 1ms DropTail
$ns duplex-link $n2 $n3 9Mb 1ms DropTail
$ns duplex-link $n3 $n4 10Mb 1ms DropTail
$ns duplex-link $n4 $n5 10Mb 1ms DropTail

$ns queue-limit $n0 $n1 5
$ns queue-limit $n1 $n2 5
$ns queue-limit $n2 $n3 5
$ns queue-limit $n3 $n4 5
$ns queue-limit $n4 $n5 5

set udp [new Agent/UDP]
$ns attach-agent $n0 $udp

set null [new Agent/Null]
$ns attach-agent $n5 $null

$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp


$cbr set packetSize_ 1000
$cbr set interval_ 0.0008


set p0 [ new Agent/Ping]
$ns attach-agent $n0 $p0

set p1 [ new Agent/Ping]
$ns attach-agent $n5 $p1

$ns connect $p0 $p1


$ns at 0.2 "$p0 send"
$ns at 0.4 "$p1 send"
$ns at 0.6 "$cbr start"
$ns at 0.8 "$p0 send"
$ns at 1.0 "$p1 send"
$ns at 1.2 "$cbr stop"
$ns at 1.4 "$p0 send"
$ns at 1.6 "$p1 send"
$ns at 1.8 "finish"

$ns run