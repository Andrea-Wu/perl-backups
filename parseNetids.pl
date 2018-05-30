#!/usr/bin/perl

$/ = "\n";

print "Enter name of file that contains UPN output [UPN.output]: ";
$input = <STDIN>; 
if ($input eq "\n"){
    $input = "UPN.output";
}else{
    chomp($input);
}

print "Enter name of file that contains list of netIDs [netid.txt]: ";
$netids = <STDIN>;
if ($netids eq "\n"){
    $netids = "netid.txt";

}else{
    chomp($netids);
}

print "Enter name of file to output [output.txt]: ";
$output = <STDIN>;
if ($output eq "\n"){
    $output = "output.txt";
}else{
    chomp($output);
}

open(READ_UPNS, $input) or die("could not open $input for reading\n");
open(READ_NETIDS, $netids) or die("could not open $netids for reading\n");
open(my $write_fh, '+>', $output) or die("could not open $output for writing\n");

#another option for checking if file is empty
#if(-z $input){
#    print "$input file is empty\n";
#}

#if(-z $netids){
#    print "$netids file is empty\n";
#}

#flags to see if file is empty
$netids_nonempty = 0;
$input_nonempty = 0;

foreach $netid (<READ_NETIDS>){

    #if all whitespace
    if($netid =~/^\s*$/){
        next;
    }
    
    $netids_nonempty = 1;

    #get rid of newline in $netid
    chomp($netid);

    #flag to see if name is found in output.txt
    $found = 0;

    foreach $line (<READ_UPNS>){
        if($line =~/^\s*$/){
            next;
        }

        $input_nonempty = 1;

        #if line contains ":" and also $netid
        if(index($line, ":") != -1  && index($line, $netid) != -1){
 
            #tokenizes line on deliminator ":"
            @tokens = split(/:/, $line);

            #write to output file
            print $write_fh ($tokens[1] . "\n");
            $found = 1;
            last;
        }
    }

    if($found == 0){
        print "netID not found: $netid\n";
    }

    #reset file handler for READ_UPNS
    seek READ_UPNS, 0, 0;

}

if($netids_nonempty == 0){
    print "$netids file is empty\n";
}

if($input_nonempty == 0){
    print "$input file is empty\n";
}


