open(READ, "ass.txt") or die("could not open file for reading");

print "opened";
$name = "ass";
foreach $line (<READ>){
    $_ = $line;
    if(/^$name/){
        print $line;
    }
}
