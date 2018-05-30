$read_file = 'UPN.output';

#the term "fh" is file handler

#opens "read_file" into file handler "READ" 
#i don't know why the syntax is different in the 2 cases, but they both behave differently
open(READ, $read_file) or die("could not open file for reading\n");

#opens filename "output.txt" for writing
#creates file if it doesn't exist, will truncate existing file with the same name
open(my $write_fh, '+>', "output.txt") or die("could not open output.txt for writing\n");

            
foreach $line (<READ>){

    #set default variable to $line so regex can parse it
    $_ = $line;

    if(/^[^the]/){
    
        #tokenizes line
        @tokens = split(/:/, $line);

        #output correct field to write_file
        print $write_fh ($tokens[1] . "\n");
    }

    

}

close(READ);
close $write_fh;


#it is safe to assume that the email that corresponds with a netid will be in the form:
#<netid>@<some.rutgers.email>


open(READ_NETIDS, "netid.txt") or die("the file netid.txt could not be opened, or does not exist\n");
open(READ_OUTPUT, "output.txt") or die("could not open output.txt for reading\n");
open(my $write_fh, '+>', "output2.txt") or die("could not open output2.txt for writing\n");


foreach $netid (<READ_NETIDS>){
      
    #get rid of newline in $netid
    $/ = "\n";
    chomp($netid);

    #flag to see if name is found in output.txt
    $found = 0;
    
    foreach $line (<READ_OUTPUT>){
        #  set default variable to $line so regex can parse it 
        $_ = $line;

        #if netid found in output, write to output2.txt
        if(/^$netid@/){
            print $write_fh ($line);
            $found = 1;
            last; 
        }
    }

    if($found == 0){
        print "netID not found: $netid\n";
    }

    #reset file handler for READ_OUTPUT to top of file
    seek READ_OUTPUT, 0,0;    
    
}

#removes intermediary file
unlink("output.txt");

close(READ);
close $write_fh;


