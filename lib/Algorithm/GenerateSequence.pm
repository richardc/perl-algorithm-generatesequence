use strict;
package Algorithm::GenerateSequence;
our $VERSION = '1.21';
use base 'Class::Accessor::Fast';

sub new {
    my $class = shift;
    $class->new({ values => [ @_ ], counters => [ map { 0 } @_ ] });
}

sub next {
    my $self = shift;

    # mmm, long addition


    my $i = 0;
    return [ map {
        $self->values->[ $i++ ][ $_ ] ]
    } @{ $self->counters } ];
}
