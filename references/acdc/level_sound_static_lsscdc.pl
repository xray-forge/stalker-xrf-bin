# S.T.A.L.K.E.R level.snd_static unpacker
# Update history:
#	v.0.2.: 10/11/2013 - level_snd_static.pm updated, usage fixed
#	v.0.1.: 27/08/2012 - initial release
###########################################################
package main;
use strict;
use Getopt::Long;
use stkutils::level::level_snd_static;
use stkutils::debug qw(fail warn STDERR_CONSOLE STDOUT_CONSOLE STDERR_FILE STDOUT_FILE);
use stkutils::chunked;
use diagnostics;
use constant FL_OLD => 0x1;

$SIG{__WARN__} = sub{fail(@_);};

sub usage {
	return <<END
S.T.A.L.K.E.R. level.snd_static compiler/decompiler
Usage: lsscdc -d level.snd_static [-o ltxfile] -old
       lsscdc -c snd_static.ltx [-o binfile]  -old
END
}

my $statics = stkutils::level::level_snd_static->new();
my $log;

GetOptions(
#global options
	'decompile:s' => \&process_glob_opt,
	'compile:s' => \&process_glob_opt,
#secondary options
	'out=s' => \$statics->{config}->{out},
	'old' => \$statics->{config}->{old},
	'log:s' => \$log,
) or die usage();

# initializing debug
my $debug_mode = STDERR_CONSOLE|STDOUT_CONSOLE;
$debug_mode = STDERR_FILE|STDOUT_FILE if defined $log;
$log = 'level_cdc.log' if defined $log && ($log eq '');
my $debug = stkutils::debug->new($debug_mode, $log);

$statics->set_flag($statics->{config}->{old}) if defined $statics->{config}->{old} && $statics->{config}->{old} == 1;

SWITCH: {
	$statics->mode() eq 'decompile' && do {decompile();last;};
	$statics->mode() eq 'compile' && do {compile();last;};
}

print "done!\n";
$debug->DESTROY();

sub process_glob_opt {
	fail('You can use only one global option. See -help or -h to learn the syntax') if $statics->get_src();
	my $config = $statics->{config};
	$config->{mode} = $_[0];
	$config->{src} = $_[1];
}
sub decompile {
	print "reading ".$statics->get_src()."\n";
	my $CDH = stkutils::chunked->new($statics->get_src(), 'r');
	$statics->read($CDH);
	$CDH->close();
	$statics->{config}->{out} = 'snd_static.ltx' if !defined $statics->{config}->{out};
	
	print "exporting ".$statics->{config}->{out}."\n";
	$statics->export($statics->{config}->{out} or 'snd_static.ltx');
}
sub compile {
	print "importing ".$statics->get_src()."\n";
	$statics->{config}->{out} = 'level.snd_static.new' if !defined $statics->{config}->{out};
	my $CDH = stkutils::chunked->new($statics->{config}->{out}, 'w');
	$statics->my_import($statics->get_src());
	
	print "writing ".$statics->{config}->{out}."\n";
	$statics->write($CDH);
	$CDH->close();
}