set ns [ new Simulator ]

$ns color 1 blue
$ns color 2 red

set tracefile [ open p6.tr w ]
$ns trace-all $tracefile

set namfile [ open p6.nam w ]
$ns namtrace-all $namfile

set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]
set n3 [ $ns node ]
set n4 [ $ns node ]
set n5 [ $ns node ]

$ns make-lan "$n0 $n1 $n2 $n3 $n4 $n5" 5Mb 10ms LL Queue/DropTail Mac/802_3

set tcp [ new Agent/TCP ]
set sink [ new Agent/TCPSink ]

$ns attach-agent $n1 $tcp
$ns attach-agent $n5 $sink

$ns connect $tcp $sink

set ftp [ new Application/FTP ]
$ftp attach-agent $tcp

$tcp set fid_ 1
$sink set fid_ 2

proc finish {} {
	global ns tracefile namfile
        $ns flush-trace
        close $tracefile
        close $namfile
        exec nam p6.nam &
        exit 0
}

$ns at 0.0 "$ftp start"
$ns at 10.0 "finish"
$ns run