$read_file = 'UPN.output';

#the term "fh" is file handler

#opens "read_file" into file handler "READ" 
#i don't know why the syntax is different in the 2 cases, but they both behave differently
open(READ, $read_file) or die("could not open file for reading");

#opens filename "output.txt" for writing
#creates file if it doesn't exist, will truncate existing file with the same name
open(my $write_fh, '+>', "output.txt") or die("could not open output.txt for writing");

            
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


#all of the email addresses are now in "output.txt". 
#it is safe to assume that the email that corresponds with a netid will be in the form:
#<netid>@<some.rutgers.email>

my $name = "";

open(READ, "output.txt") or die("did not open output.txt for reading");
open(my $write_fh, '+>', "output2.txt") or die("could not open output2.txt for writing");

print "Type 'bye' to finish entering names\n";

while($name ne "bye"){
    print "Enter a netID to search:";

    $name = <STDIN>;
      

    #get rid of newline in $name
    $/ = "\n";
    chomp($name);

    #flag to see if name is found in output.txt
    $found = 0;
    
    foreach $line (<READ>){
        #  set default variable to $line so regex can parse it 
        $_ = $line;
        if(/^$name@/){
            print $write_fh ($line);
            $found = 1;
            last; #same as break
        }
    }

    if($found == 0 && $name ne "bye" ){
        print "netID not found: $name\n";
    }

    #reset file handler to top of file
    seek READ, 0,0;    
    
}

close(READ);
close $write_fh;


