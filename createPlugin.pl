#!/usr/bin/env perl
# Build, upload and promote PluginLite
use Getopt::Long;
use XML::Simple qw(:strict);
use Data::Dumper;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use Archive::Zip::Tree;
use strict;
use ElectricCommander ();
$| = 1;
my $ec = new ElectricCommander->new();

my $version = "1.8";
# Revision history
#	1.8   - Add link and tokenize plugin name in help.xml
#	1.7.2 - Multi-DSL issue: commonProp was not being included in header
#	1.7.1 - Laurent removed log file writing, now only writes to plugin project property
#
#
my $pluginKey = "PluginLite";
my $description = "Ultra light plugin customized with DSL";
GetOptions ("version=s" => \$version,
			"pluginKey=s"   => \$pluginKey,
			"description=s"  => \$description
			) or die(qq(
Error in command line arguments

	createPlugin.pl
		[--version <version>]
		[--pluginKey <version>]
		[--description <version>]

		)
);

my $pluginName = "${pluginKey}-${version}";

my $xs = XML::Simple->new(
	ForceArray => 1,
	KeyAttr    => { },
	KeepRoot   => 1,
);

# Update project.xml with ec_setup.pl
print "[INFO] - Processing 'META-INF/project.xml' file...\n";
my $xmlFile = "META-INF/project.xml";
my $file = "ec_setup.pl";
my $value;
{
  local $/ = undef;
  open FILE, $file or die "Couldn't open file: $!";
  binmode FILE;
  $value = <FILE>;
  close FILE;
}
my $ref  = $xs->XMLin($xmlFile);
$ref->{exportedData}[0]->{project}[0]->{propertySheet}[0]->{property}[0]->{value}[0] = $value;
open(my $fh, '>', $xmlFile) or die "Could not open file '$xmlFile' $!";
print $fh $xs->XMLout($ref);
close $fh;

# Update plugin.xml with key, version, label, description
print "[INFO] - Processing 'META-INF/plugin.xml' file...\n";
$xmlFile = "META-INF/plugin.xml";
$ref  = $xs->XMLin($xmlFile);
$ref->{plugin}[0]->{key}[0] = $pluginKey;
$ref->{plugin}[0]->{version}[0] = $version;
$ref->{plugin}[0]->{label}[0] = $pluginKey;
$ref->{plugin}[0]->{description}[0] = $description;
open(my $fh, '>', $xmlFile) or die "Could not open file '$xmlFile' $!";
print $fh $xs->XMLout($ref);
close $fh;

# Replace @PLUGIN_NAME@ with $pluginKey
# Update help.xml
my $inFile = "help.xml";
print "[INFO] - Processing '$inFile' file...\n";
open(FILE, "<$inFile") || die "Could not open file '$inFile' $!";
my @lines = <FILE>;
close(FILE);

my @newlines;
foreach(@lines) {
   $_ =~ s/\@PLUGIN_NAME\@/$pluginKey/g;
   push(@newlines,$_);
}

open(FILE, ">pages/$inFile") || die "Could not open file 'pages/$inFile' $!";
print FILE @newlines;
close(FILE);

# Create plugin jar file
print "[INFO] - Creating plugin jar file, ${pluginKey}.jar\n";
my $zip = Archive::Zip->new();
my $directory = '.';
opendir (DIR, $directory) or die $!;
while (my $file = readdir(DIR)) {
	$zip->addTree( $file, $file ) unless (
		$file eq "${pluginKey}.jar" or
		$file eq ".git" or
		$file eq "." or
		$file eq ".."
		);
}
# Save the Zip file
unless ( $zip->writeToFileNamed("${pluginKey}.jar") == AZ_OK ) {
	die 'write error';
}

# Uninstall old plugin
print "[INFO] - Uninstalling old plugin...\n";
$ec->uninstallPlugin($pluginName) || print "No old plugin\n";

# Install plugin
print "[INFO] - Installing plugin...\n";
$ec->installPlugin("${pluginKey}.jar");

# Promote plugin
print "[INFO] - Promoting plugin...\n";
$ec->promotePlugin($pluginName);
