4. Implement simple ESS and with transmitting nodes in wire-less LAN by simulation
and determine the performance with respect to transmission of packets.
set ns [new Simulator]
set na [open p10.nam w]
$ns namtrace-all-wireless $na 500 500
set nt [open p10.tr w]
$ns trace-all $nt
set topo [new Topography]
$topo load_flatgrid 500 500
$ns node-config -adhocRouting DSDV
$ns node-config -llType LL
$ns node-config -macType Mac/802_11
$ns node-config -ifqType Queue/DropTail
$ns node-config -ifqLen 50
$ns node-config -phyType Phy/WirelessPhy
$ns node-config -channelType Channel/WirelessChannel
$ns node-config -propType Propagation/TwoRayGround
$ns node-config -antType Antenna/OmniAntenna
$ns node-config -topoInstance $topo
$ns node-config -agentTrace ON
$ns node-config -routerTrace ON
create-god 4
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
$n0 set X_ 250.0
$n0 set Y_ 250.0
$n0 set Z_ 0.0
$n1 set X_ 200.0
$n1 set Y_ 250.0
$n1 set Z_ 0.0
$n2 set X_ 250.0
$n2 set Y_ 250.0
$n2 set Z_ 0.0
$n3 set X_ 250.0
$n3 set Y_ 250.0
$n3 set Z_ 0.0
$ns at 0.0 "$n0 setdest 400.0 300.0 50.0"
$ns at 0.0 "$n1 setdest 50.0 100.0 20.0"
$ns at 0.0 "$n2 setdest 75.0 180.0 5.0"
$ns at 0.0 "$n3 setdest 100.0 100.0 25.0"
set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1
set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
set sink2 [new Agent/TCPSink]
$ns attach-agent $n3 $sink2
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $tcp1
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $tcp2
$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2
proc End {} {
global ns nt na
$ns flush-trace
close $na
close $nt
exec nam p10.nam &
exec awk -f p10.awk p10.tr &
}
$ns at 0.0 "$cbr1 start"
$ns at 0.0 "$cbr2 start"
$ns at 10.0 "End"
$ns run
