#!/usr/local/bin/perl

# http://x68000.q-e-d.net/~68user/net/sample/tcpdump-filter.pl
#
# $Id: tcpdump-filter.pl,v 1.2 2002/02/17 11:07:28 68user Exp $

while(<STDIN>){
    if(m/^[ \t]/){
        $store .= $_
    } else {
        s/^[^ ]* //;
        s/:[^:]*$//;
        print "$_\n";
        $_ = $store;
        s/\s//g;
        s/^.{120}//;
        s/[0-9A-Fa-f][0-9A-Fa-f]/pack("C", hex $&)/eg;
        s/[\x00-\x08\x0a-\x1f\x7f-\xff]/ /g;
        print "$_\n";
        $store = "";
    }
}
