# S.T.A.L.K.E.R level.ps_static unpacker
# Update history:
#	v.0.1.: 17/01/2013 - initial release
###########################################################
package main;
use strict;
use Getopt::Long;
use stkutils::level::level_ps_static;
use stkutils::debug qw(fail warn STDERR_CONSOLE STDOUT_CONSOLE STDERR_FILE STDOUT_FILE);
use stkutils::chunked;
use diagnostics;

$SIG{__WARN__} = sub{fail(@_);};

sub usage {
	return <<END
S.T.A.L.K.E.R. level.ps_static compiler/decompiler
Usage: lpscdc -d level.snd_static [-o ltxfile]
       lpscdc -c snd_static.ltx [-o binfile]
END
}

my $statics = stkutils::level::level_ps_static->new();
my ($log, $config);

GetOptions(
#global options
	'decompile:s' => \&process_glob_opt,
	'compile:s' => \&process_glob_opt,
#secondary options
	'out=s' => \$config->{out},
	'cs' => \$config->{flag},
	'log:s' => \$log,
) or die usage();

# initializing debug
my $debug_mode = STDERR_CONSOLE|STDOUT_CONSOLE;
$debug_mode = STDERR_FILE|STDOUT_FILE if defined $log;
$log = 'level_cdc.log' if defined $log && ($log eq '');
my $debug = stkutils::debug->new($debug_mode, $log);

$statics->{flag} = $config->{flag} if defined $config->{flag};
	
SWITCH: {
	$config->{mode} eq 'decompile' && do {decompile();last;};
	$config->{mode} eq 'compile' && do {compile();last;};
}

print "done!\n";
$debug->DESTROY();

sub process_glob_opt {
	fail('You can use only one global option. See -help or -h to learn the syntax') if $config->{src};
	$config->{mode} = $_[0];
	$config->{src} = $_[1];
}
sub decompile {
	print "reading ".$config->{src}."\n";
	my $CDH = stkutils::chunked->new($config->{src}, 'r');
	$statics->read($CDH);
	$CDH->close();
	$config->{out} = 'ps_static.ltx' if !defined $config->{out};
	
	print "exporting ".$config->{out}."\n";
	$statics->export($config->{out} or 'ps_static.ltx');
}
sub compile {
	print "importing ".$config->{src}."\n";
	$config->{out} = 'level.ps_static.new' if !defined $config->{out};
	my $CDH = stkutils::chunked->new($config->{out}, 'w');
	$statics->my_import($config->{src});
	
	print "writing ".$config->{out}."\n";
	$statics->write($CDH);
	$CDH->close();
}