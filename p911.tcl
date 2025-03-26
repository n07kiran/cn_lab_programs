set ns [new Simulator]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

set nf [open gbn.nam w]
$ns namtrace-all $nf
set f [open gbn.tr w]
$ns trace-all $f

$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n3 $n5 1Mb 10ms DropTail

Agent/TCP set_nam_tracevar_true
set tcp [new Agent/TCP]
$tcp set fid_ 1
$tcp set windowInit_ 3
$tcp set maxcwnd_ 3
$ns attach-agent $n1 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

# Start FTP traffic at t=0.05 seconds
$ns at 0.05 "$ftp start"
$ns at 0.25 "$ns queue-limit $n3 $n4 0"
$ns at 0.30 "$ns queue-limit $n3 $n4 3"
$ns at 1.0 "finish"

proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam gbn.nam &
    exit 0
}

$ns run