set ns [new Simulator]

set tracefile [open p3.tr w]
$ns trace-all $tracefile

set namfile [open p3.nam w]
$ns namtrace-all $namfile

set xg1 [open tcp1.xg w]

set xg2 [open tcp2.xg w]


proc finish { } {
	global ns tracefile namfile xg1 xg2
	$ns flush-trace
	close $tracefile
	close $namfile
	close $xg1
	close $xg2
	exec nam p3.nam &
	exec xgraph tcp1.xg tcp2.xg &
	exit 0
}


proc Draw {Agent File} {
	global ns
	set Cong [$Agent set cwnd_]
	set Time [$ns now]
	puts $File "$Time $Cong"
	$ns at [ expr $Time+0.01 ] "Draw $Agent $File"
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]


$ns make-lan "$n0 $n1 $n2" 1Mb 10ms LL Queue/DropTail Mac/802_3
$ns make-lan "$n3 $n4 $n5" 2Mb 10ms LL Queue/DropTail Mac/802_3


$ns duplex-link $n0 $n3 10Mb 10ms DropTail

set tcp1 [new Agent/TCP]
set tcp2 [new Agent/TCP]

set sink1 [new Agent/TCPSink]
set sink2 [new Agent/TCPSink]

$ns attach-agent $n4 $tcp1
$ns attach-agent $n2 $sink1
$ns connect $tcp1 $sink1

$ns attach-agent $n1 $tcp2
$ns attach-agent $n5 $sink2
$ns connect $tcp2 $sink2

set ftp1 [new Application/FTP]
set ftp2 [new Application/FTP]

$ftp1 attach-agent $tcp1
$ftp2 attach-agent $tcp2

$ns at 0.0 "$ftp1 start"
$ns at 0.7 "$ftp2 start"
$ns at 0.0 "Draw $tcp1 $xg1"
$ns at 0.0 "Draw $tcp2 $xg2"
$ns at 10.0 "finish"
$ns run