#!perl -w
use strict;
use Test::More tests => 10;

my $class = 'Algorithm::GenerateSequence';
require_ok( $class );
my $iter = $class->new(
    [qw( alpha beta )], [qw( one two )], [qw( one two three )] );

isa_ok( $iter, $class );
is_deeply( $class->next, [qw( alpha one one )] );
is_deeply( $class->next, [qw( alpha one two )] );
is_deeply( $class->next, [qw( alpha one three )] );
is_deeply( $class->next, [qw( alpha two one )] );
is_deeply( $class->next, [qw( alpha two two )] );
is_deeply( $class->next, [qw( alpha two three )] );
is_deeply( $class->next, [qw( beta one one )] );
is_deeply( $class->next, [qw( beta one two )] );
is_deeply( $class->next, [qw( beta one three )] );
