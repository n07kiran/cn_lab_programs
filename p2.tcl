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
	exec nam p2.nam &
	exec echo "No of dropped ping packets dropped are : " &
	exec grep ^d p2.tr | cut -d " " -f 5 | grep -c "ping" &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 0.5Mb 10ms DropTail
$ns duplex-link $n1 $n2 0.5Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.4Mb 10ms DropTail
$ns duplex-link $n3 $n4 0.5Mb 10ms DropTail
$ns duplex-link $n4 $n5 0.5Mb 10ms DropTail

Agent/Ping instproc recv {from rtt} {
	$self instvar node_
	#set node_ $node
	puts "node [$node_ id] recieved ping response from node $from , rtt : $rtt ms" 
}

$ns queue-limit $n0 $n1 5
$ns queue-limit $n1 $n2 5
$ns queue-limit $n2 $n3 5
$ns queue-limit $n3 $n4 5
$ns queue-limit $n4 $n5 5


set p0 [new Agent/Ping]
$ns attach-agent $n0 $p0

set p1 [new Agent/Ping]
$ns attach-agent $n5 $p1

$p0 set class_ 1
$p1 set class_ 1

$ns connect $p0 $p1


set udp [new Agent/UDP]
$ns attach-agent $n0 $udp

set null [new Agent/Null]
$ns attach-agent $n5 $null

$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp


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