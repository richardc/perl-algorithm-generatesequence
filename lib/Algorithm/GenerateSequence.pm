use strict;
use diagnostics;
package Algorithm::GenerateSequence;
our $VERSION = '1.21';
use base 'Class::Accessor::Fast';
__PACKAGE__->mk_accessors(qw( _values _counters _started _ended ));

=head1 NAME

Algorithm::GenerateSequence - a sequence generator

=head1 SYNOPSIS

 my $gen = Algorithm::GenerateSequence->new(
    [qw( one two three )], [qw( hey bee )],
 );
 print $gen->next, "\n"; # onehey
 print $gen->next, "\n"; # onebee
 print $gen->next, "\n"; # twohey
 print $gen->next, "\n"; # twobee
 ...

=head1 DESCRIPTION

=head1 METHODS

=head2 new( @values );

values contains arrays of values which will be treated in sequence

=cut

sub new {
    my $class = shift;
    $class->SUPER::new({
        _values   => [ @_ ],
        _counters => [ map { 0 } @_ ],
    });
}

=head1 next

returns a list containing the next value in the sequence, false after
the end of the list.

=cut

sub next {
    my $self = shift;

    return if $self->_ended;

    if ($self->_started) {
        my $max = @{ $self->_counters } - 1;

        # mmm, long addition
        do {
            my $new = ++$self->_counters->[ $max ];
            # check for overflow
            goto DONE if $new % @{ $self->_values->[ $max ] };
            $self->_counters->[ $max ] = 0;
        } while --$max >= 0;
      DONE:
        if ($max < 0) {
            $self->_ended(1);
            return;
        }
    }
    $self->_started(1);

    my $i = 0;
    return map {
        $self->_values->[ $i++ ][ $_ ]
    } @{ $self->_counters };
}

=head2 reset

reset the iterator

=cut

sub reset {
    my $self = shift;
    $_ = 0 for @{ $self->_counters };
    $self->_started(0);
    $self->_ended(0);
}

=head2 as_list

return the entire set as a list of arrays

=cut

sub as_list {
    my $self = shift;
    $self->reset;
    my @results;

    while (my @next = $self->next) {
        push @results, \@next;
    }

    $self->reset;
    return @results;
}

1;
__END__
