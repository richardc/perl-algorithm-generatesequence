use strict;
use diagnostics;
package Algorithm::GenerateSequence;
our $VERSION = '1.21';
use base 'Class::Accessor::Fast';
__PACKAGE__->mk_accessors(qw( _values _counters _started _ended ));

=head1 NAME

Algorithm::GenerateSequence - a sequence generator

=head1 SYNOPSIS

=head1 METHODS

=head2 new

=cut

sub new {
    my $class = shift;
    $class->SUPER::new({
        _values   => [ @_ ],
        _counters => [ map { 0 } @_ ],
    });
}

sub reset {
    my $self = shift;
    $_ = 0 for @{ $self->_counters };
    $self->_started(0);
    $self->_ended(0);
}

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
