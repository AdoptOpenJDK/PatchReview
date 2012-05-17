#!/usr/bin/perl -w

# Modified By John Oliver to remove directory from names produced

# diffsplit - split up unified diffs
#
# Copyright (C) 2001-2002  Transmeta Corporation
#
# written by Daniel Quinlan <quinlan@transmeta.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

$prog = $0;
$prog =~ s@.*/@@;

use Getopt::Std;
use vars qw($opt_d $opt_h $opt_q $opt_t);

if (defined($ENV{DIFFSPLIT})) {
	unshift(@ARGV, $ENV{DIFFSPLIT});
}

getopts("b:cdho:p:qs:t");

if ($#ARGV < 0) {
	push(@ARGV, "-");
}

if ($opt_h) {
	usage(0);
}
if ($opt_c) {
	$regexp = '^Index:\s+(.*)';
}
else {
	$regexp = '^diff\s+.*\s+(\S+)';
}

foreach $file (@ARGV) {
	if (!open(IN, $file)) {
		warn("$prog: $file: $!\n");
		next;
	}
	$out = '';
	$name = 'header';
	$in_header = 0;
	while(<IN>) {
		if (/^@@/) {
			$in_header = 0;
		}
		if ($opt_c) {
			s/^([-+][-+][-+]) (\S+)/$1 $name/;
		}
		if (/$regexp/ ||
		    (! $in_header && /^(\-\-\-) (\S+)/ && ($no_name = 1)))
		{
			# save last file
			$last = $name;
			&close_file($last);

			$in_header = 1;

			$name = $1;

			if ($no_name) {
				$no_name = 0;
				$out .= $_;
				$_ = <IN>;
				if (/^\+\+\+ (\S+)/) {
					$name = $1;
				}
			}
		}
		$out .= $_;
	}
	&close_file($name);
	close(IN);
}

sub close_file {
	my ($name) = @_;
	my $orig;

	if ($opt_p) {
		$name =~ s/^$opt_p//;
	}
	if ($opt_b) {
		$name =~ s/^/$opt_b/;
	}
	$orig = $name;
	if ($out ne '') {
		if ($opt_d) {
			$name =~ s@/[^/]+$@@;
		}
		if ($opt_o) {
			$name = $opt_o;
		}
		if ($opt_s && $name ne "header") {
			$name .= $opt_s;
		}
		$name =~ s/.*(\/)/$1/gx;
		$name =~ s/\///g;

		if (-e $name && ! $seen{$name}) {
			die "$prog: \"$name\" already exists, stopping\n";
		}
		if (! $opt_q) {
			print STDERR "file: $orig -> $name\n";
		}
		if (! $opt_t) {
			open(OUT, ">> $name");
			print OUT $out;
			close(OUT);
		}
		$seen{$name}++;
		$out = '';
	}
}

sub usage {
	$status = shift;

	$out = $status ? STDERR : STDOUT;
	print $out <<EOF;
usage: $prog [options] [file ...]

Split up unified diffs.  If no files are supplied, operates on standard input.

 -b begin   add begin to the front of each filename
 -c         input is a CVS diff (splits correctly and fixes diff filenames)
 -d         split by directory name instead of filename
 -h         print this help
 -o file    create a single output file, "-" outputs to stdout (useful with -c)
 -p prefix  strip prefix from the front of each filename (use / characters)
 -q         run quietly
 -s .suf    use suffix .suf on created files (default is no suffix)
 -t         test run (no writes)
EOF
	exit($status);
}
