#!/usr/bin/perl

use strict;
use warnings;

binmode STDOUT, ":utf8";
use utf8;

use JSON::Parse 'json_file_to_perl';
use Data::Dumper;
use Node;
use VisitorStmt;

sub block_code
{
    eval {
        translate (@_);
    };
    warn $@ if $@;

}

sub translate
{
    my $name = shift;
    my $path = '../js/' . $name;

    my $data = json_file_to_perl ($path.'.js');

    dump_to_file ($name, $data);

    my $tree = Node->new ($data);

    my $visitor = VisitorStmt->new();

    $visitor->stmt($data, $path . '.tcl');
}

sub dump_to_file
{
    my $name = shift;
    my $data = shift;
    open my $FH, '>', '../js/'. $name . '.pl';
    print $FH Dumper($data);
    close $FH;
}

block_code('hw');
block_code('tpk');

