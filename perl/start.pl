#!/usr/bin/env perl
package Code::Languages;

use v5.16;
use warnings;
use autodie;

my $v = "Test";

# some bashisms
print "$v has some values\n";
print '$v is not quoted', "\n";
print `pwd`;

my $refV = \$v; # reference to $v
print $refV, "\n";

my @home = ("apple", "banana", "peach");
my ($item1, $item2, $item3) = @home; # destructure, or list assignment

my %uninit; # declare without initialization

%uninit = (
    "A" => 1,
    "B" => 2,
);
print keys(%uninit), "\n";
print $uninit{"A"}, "\n";

$uninit{"C"} = ["A", "B"]; # force an array as a scalar

$uninit{"D"} = {
    "FM" => "AFD",
    "fd" => "afd",
};
