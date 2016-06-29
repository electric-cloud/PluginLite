
use Cwd;
use Data::Dumper;
use File::Spec;

my $dir = getcwd;
my $logfile ="";
if(defined $ENV{'QUERY_STRING'}) { # Promotion through UI
	$logfile = "/tmp/log.txt";
} else {
	$logfile = "$ENV{'TEMP'}/log.txt";
}
open(my $fh, '>', $logfile) or die "Could not open file '$logfile' $!";
print $fh "Plugin Name: $pluginName\n";
print $fh "Current directory: $dir\n";

if ($promoteAction eq 'promote') {
	local $/ = undef;
	# If env variable QUERY_STRING exists:
	if(defined $ENV{'QUERY_STRING'}) { # Promotion through UI
		open FILE, "../../$pluginName/dsl/main.groovy" or die "Couldn't open file: $!";
	} else {  # Promotion from the command line
		open FILE, "dsl/main.groovy" or die "Couldn't open file: $!";
	}
	my $dsl = <FILE>;
	close FILE;
	my $dslReponse = $commander->evalDsl($dsl,
			{parameters=>qq(
				{
					"pluginName":"$pluginName"
				}
			)}
	);
	print $fh Dumper $dslReponse;#->findvalue("//response")->string_value;
} elsif ($promoteAction eq 'demote') {
}

close $fh;

# TODO: create log file output property
open LOGFILE, $logfile or die "Couldn't open file: $!";
my $logFileContent = <LOGFILE>;
my $propertyResponse = $commander->setProperty("/plugins/$pluginName/projects/logfile",
			{value=>$logFileContent}
	);
close LOGFILE;
