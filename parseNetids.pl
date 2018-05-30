#!/usr/bin/perl

$/ = "\n";

print "Enter name of file that contains UPN output [UPN.output]: ";
$input = <STDIN>;
chomp($input); 
if ($input eq ""){
    $input = "UPN.output";
}

print "Enter name of file that contains list of netIDs [netid.txt]: ";
$netids = <STDIN>;
chomp($netids);
if ($netids eq ""){
    $netids = "netid.txt";
}

print "Enter name of file to output email addresses [email_output.txt]: ";
$email = <STDIN>;
chomp($email);
if ($email eq ""){
    $email = "email_output.txt";
}

print "Enter name of file to output sharepoint sites [sharepoint_output.txt]: ";
$sharepoint = <STDIN>;
chomp($sharepoint);
if ($sharepoint eq ""){
    $sharepoint = "sharepoint_output.txt";
}


open(READ_UPNS, $input) or die("could not open $input for reading\n");
open(READ_NETIDS, $netids) or die("could not open $netids for reading\n");
open(my $write_emails, '+>', $email) or die("could not open $email for writing\n");
open(my $write_sharepoint, '+>', $sharepoint) or die("could not open $sharepoint for writing\n");

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

    #flag to see if name is found in $input
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
            print $write_emails ($tokens[1] . "\n");
            $found = 1;
            last;
        }
    }

    if($found == 0){
        print "netID not found: $netid\n";
    }else{ 
        
        #put sharepoint stuff into separate file
        $newToken = $tokens[1];

        $newToken =~ s/@/_/;
        $newToken =~ s/\./_/g;
        
        $sharepoint_string = "https://rutgersconnect-my.sharepoint.com/personal/" . $newToken . "\n"; 
        print $write_sharepoint $sharepoint_string;
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


