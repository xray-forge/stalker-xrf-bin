# S.T.A.L.K.E.R. lanims.xr compiler/decompiler
# Update history:
#	v.0.2. 29/08/2012 - complete refactoring
#	v.0.1: 		first release
##############################################
use strict;
use Getopt::Long;
use stkutils::chunked;
use stkutils::debug qw(fail warn STDERR_CONSOLE STDOUT_CONSOLE STDERR_FILE STDOUT_FILE);
use stkutils::xr::lanims_xr;
use stkutils::utils qw(read_file write_file);
use stkutils::ini_file;
use diagnostics;

# handle signals
$SIG{__WARN__} = sub{fail(@_);};

# parsing command line
my ($src, $out, $mode, $log, $rgb);
GetOptions(
	# main options
	'decompile:s' => \&process,
	'compile:s' => \&process,
	# common options
	'out=s' => \$out,	
	'log:s' => \$log,
	'rgb' => \$rgb,
) or die usage();

# initializing debug
my $debug_mode = STDERR_CONSOLE|STDOUT_CONSOLE;
$debug_mode = STDERR_FILE|STDOUT_FILE if defined $log;
$log = 'lxrcdc.log' if defined $log && ($log eq '');
my $debug = stkutils::debug->new($debug_mode, $log);

# start processing
SWITCH: {
	($mode eq 'decompile') && do {decompile(); last SWITCH;};
	($mode eq 'compile') && do {compile(); last SWITCH;};
}

print "done!\n";
$debug->DESTROY();

sub usage {
	print "lanims.xr compiler/decompiler\n";
	print "Usage:\n";
	print "decompile:	lxrcdc.pl -d <filename> [-out <path> -log <log_filename>]\n";
	print "compile:	lxrcdc.pl -c <path> [-out <filename> -log <log_filename>]\n";
}
sub process {
	$mode = $_[0];
	$src = $_[1];
}
sub decompile {
	$src = 'lanims.xr' if $src eq '';
	
	print "opening $src\n";
	my $data = read_file($src) or fail("$!: $src\n");
	my $sxxr = stkutils::xr::lanims_xr->new($data);
	$sxxr->read();
	$sxxr->export($out, $rgb);
}
sub compile {
	$out = 'lanims.xr.new' if (!defined $out or ($out eq ''));
	
	print "opening $src\n";
	my $sxxr = stkutils::xr::lanims_xr->new();
	$sxxr->my_import($src);
	$sxxr->write();
	write_file($out, $sxxr->{data});
}