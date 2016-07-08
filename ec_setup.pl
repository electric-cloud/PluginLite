use Cwd;
use File::Spec;

my $dir = getcwd;
my $logfile ="";
if(defined $ENV{'QUERY_STRING'}) { # Promotion through UI
	$logfile = "../../$pluginName/ec_setup.log";
} else {
	$logfile = "$ENV{'TEMP'}/ec_setup.log";
}
open(my $fh, '>', $logfile) or die "Could not open file '$logfile' $!";
print $fh "Plugin Name: $pluginName\n";
print $fh "Current directory: $dir\n";

# Evaluate promote.groovy or demote.groovy based on whether plugin is being promoted or demoted ($promoteAction)
local $/ = undef;
# If env variable QUERY_STRING exists:
if(defined $ENV{'QUERY_STRING'}) { # Promotion through UI
	open FILE, "../../$pluginName/dsl/$promoteAction.groovy" or die "Couldn't open file: $!";
} else {  # Promotion from the command line
	open FILE, "dsl/$promoteAction.groovy" or die "Couldn't open file: $!";
}
my $dsl = <FILE>;
close FILE;
my $dslReponse = $commander->evalDsl($dsl,
		{parameters=>qq(
			{
				"pluginName":"$pluginName"
			}
		)}
)->findnodes_as_string("/");
print $fh $dslReponse;

close $fh;

# Create log file output property
open LOGFILE, $logfile or die "Couldn't open file: $!";
my $logFileContent = <LOGFILE>;
my $propertyResponse = $commander->setProperty("/plugins/$pluginName/project/ec_setup.log",
			{value=>$logFileContent}
	);
close LOGFILE;
