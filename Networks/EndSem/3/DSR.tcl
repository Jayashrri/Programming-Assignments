set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            CMUPriQueue     ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             10                         ;# number of mobilenodes
set val(rp)             DSR                     ;# routing protocol
set val(x)              1000   			   ;# X dimension of topography
set val(y)              500   			   ;# Y dimension of topography  
set val(stop)		    150			   ;# time of simulation end

set ns [new Simulator] 

set tracefd [open dsr.tr w]
$ns trace-all $tracefd


#Creation of Network Animation file
set namtrace [open dsr.nam w]    
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y); # No z-axis in flatgrid (2D)

#GOD creation- General Operations Director
#GOD object handles the routing, packet exchange etc...
create-god $val(nn)

#Create nn mobilenodes [$val(nn)] and attach them to the channel. 


# configure the nodes
        $ns node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace ON \
			 -movementTrace ON

# Provide initial location of mobilenodes
set n_0 [$ns node]
$n_0 set X_ 990
$n_0 set Y_ 490
$n_0 set Z_ 0
$n_0 random-motion 0
$ns initial_node_pos $n_0 20

set n_1 [$ns node]
$n_1 set X_ 10
$n_1 set Y_ 250
$n_1 set Z_ 0
$n_1 random-motion 0
$ns initial_node_pos $n_1 20

set n_2 [$ns node]
$n_2 set X_ 200
$n_2 set Y_ 350
$n_2 set Z_ 0
$n_2 random-motion 0
$ns initial_node_pos $n_2 20

set n_3 [$ns node]
$n_3 set X_ 200
$n_3 set Y_ 150
$n_3 set Z_ 0
$n_3 random-motion 0
$ns initial_node_pos $n_3 20

set n_4 [$ns node]
$n_4 set X_ 400
$n_4 set Y_ 150
$n_4 set Z_ 0
$n_4 random-motion 0
$ns initial_node_pos $n_4 20

set n_5 [$ns node]
$n_5 set X_ 400
$n_5 set Y_ 250
$n_5 set Z_ 0
$n_5 random-motion 0
$ns initial_node_pos $n_5 20

set n_6 [$ns node]
$n_6 set X_ 400
$n_6 set Y_ 350
$n_6 set Z_ 0
$n_6 random-motion 0
$ns initial_node_pos $n_6 20

set n_7 [$ns node]
$n_7 set X_ 600
$n_7 set Y_ 150
$n_7 set Z_ 0
$n_7 random-motion 0
$ns initial_node_pos $n_7 20

set n_8 [$ns node]
$n_8 set X_ 700
$n_8 set Y_ 300
$n_8 set Z_ 0
$n_8 random-motion 0
$ns initial_node_pos $n_8 20

set n_9 [$ns node]
$n_9 set X_ 500
$n_9 set Y_ 350
$n_9 set Z_ 0
$n_9 random-motion 0
$ns initial_node_pos $n_9 20

# Generation of movements
$ns at 10.0 "$n_6 setdest 990.0 490.0 20.0"
$ns at 20.0 "$n_6 setdest 400.0 350.0 20.0" 

set udp [new Agent/UDP]
$ns attach-agent $n_1 $udp

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packet_size_ 1000
$cbr set interval_ 0.2


set null1 [new Agent/Null]
$ns attach-agent $n_9 $null1

$ns connect $udp $null1

$ns at 2.0 "$cbr start" 

set tcp [new Agent/TCP]
$ns attach-agent $n_1 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n_8 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 30.0 "$ftp start" 

# ending nam and the simulation 
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
    exec awk -f pdr.awk dsr.tr > dsr_pdr.xg &
    exec awk -f delay.awk dsr.tr > dsr_delay.xg &
    exec awk -f throughput.awk dsr.tr > dsr_throughput.xg
exec nam dsr.nam &
exit 0
}

$ns run

