set ns [new Simulator]

set val(x) 500
set val(y) 500
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

$ns node-config -llType         LL
$ns node-config   -ifqType        "Queue/DropTail/PriQueue"
$ns node-config   -ifqLen         50
$ns node-config   -macType        Mac/802_11
$ns node-config    -phyType        "Phy/WirelessPhy"

$ns node-config   -addressingType flat 
$ns node-config    -adhocRouting   DSR 
$ns node-config    -propType       "Propagation/TwoRayGround"
$ns node-config     -antType        "Antenna/OmniAntenna"
$ns node-config    -channelType    "Channel/WirelessChannel"
$ns node-config     -topoInstance   $topo

$ns node-config     -agentTrace     ON 
$ns node-config     -routerTrace    ON 
$ns node-config     -macTrace       OFF
$ns node-config   -movementTrace  ON

set val(nn) 7 ;# number of mobilenodes




set nf [open out.nam w]
$ns namtrace-all-wireless $nf $val(x) $val(y)


set nf1 [open tcp_out.tr w]
$ns trace-all $nf1
create-god $val(nn)

proc finish {} {
    global ns nf null1 nf1 
    $ns flush-trace
    close $nf
    exec nam out.nam &
    exec awk -f pdr.awk tcp_out.tr > pdr.xg &
    exec awk -f throughput.awk tcp_out.tr > throughput.xg &
    exec awk -f delay.awk tcp_out.tr > delay.xg &
    exec awk -f packet_loss.awk tcp_out.tr > packet_loss.xg &
    exit 0
}

for {set i 0} {$i < $val(nn)} {incr i} {
    set n_$i [$ns node]
    #$n_$i set X_ [expr rand()*$val(x)]
    #$n_$i set Y_ [expr rand()*$val(y)]
    #$n_$i set Z_ 0
}

$n_0 color blue
$n_1 color green
$n_2 color yellow
$n_3 color orange
$n_4 color black
$n_5 color red
$n_6 color blue


    $n_0 set X_ 123
    $n_0 set Y_ 232
    $n_0 set Z_ 0
    
    $n_1 set X_ 166
    $n_1 set Y_ 211
    $n_1 set Z_ 0
    
    $n_2 set X_ 435
    $n_2 set Y_ 264
    $n_2 set Z_ 0

    $n_3 set X_ 333
    $n_3 set Y_ 111
    $n_3 set Z_ 0

    $n_4 set X_ 12
    $n_4 set Y_ 22
    $n_4 set Z_ 0

    $n_5 set X_ 25
    $n_5 set Y_ 35
    $n_5 set Z_ 0

    $n_6 set X_ 323
    $n_6 set Y_ 432
    $n_6 set Z_ 0



$ns initial_node_pos $n_6  30
$ns initial_node_pos $n_5 30
$ns initial_node_pos $n_4 30
$ns initial_node_pos $n_3 30
$ns initial_node_pos $n_2 30
$ns initial_node_pos $n_1  30
$ns initial_node_pos $n_0 30

set tcp [new Agent/TCP]
$ns attach-agent $n_3 $tcp

set udp [new Agent/UDP]
$ns attach-agent $n_0 $udp

set null1 [new Agent/Null]
$ns attach-agent $n_6 $null1

set sink [new Agent/TCPSink]
$ns attach-agent $n_6 $sink


$ns connect $tcp $sink
$ns connect $udp $null1

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packetSize_ 1024
$cbr set interval_ 0.2


$ns at 2.0 "$cbr start"
$ns at 10.0 "$n_5 setdest  45.0 35.0 10.0"
$ns at 20.0 "$n_5 setdest  25.0 35.0 10.0"
$ns at 30.0 "$ftp start"
$ns at 35.0 "$cbr stop"
$ns at 35.0 "$ftp stop"
$ns at 35.0 "finish"
$ns run
