###########################################################################
# whatbot/Component.pm
###########################################################################
# base class for all whatbot components. add this to each component of
# whatbot to give base functionality.
###########################################################################
# the whatbot project - http://www.whatbot.org
###########################################################################

use MooseX::Declare;

class whatbot::Component {
    has 'base_component' => ( is => 'rw', default => sub { whatbot::Component::Base->new() } );
    has 'parent'         => ( is => 'rw', default => sub { $_[0]->base_component->parent } );
    has 'config'         => ( is => 'rw', default => sub { $_[0]->base_component->config } );
    has 'ios'            => ( is => 'rw', default => sub { $_[0]->base_component->ios } );
    has 'database'       => ( is => 'rw', default => sub { $_[0]->base_component->database } );
    has 'log'            => ( is => 'rw', default => sub { $_[0]->base_component->log } );
    has 'controller'     => ( is => 'rw', default => sub { $_[0]->base_component->controller } );
    has 'timer'          => ( is => 'rw', default => sub { $_[0]->base_component->timer } );
    has 'models'         => ( is => 'rw', default => sub { $_[0]->base_component->models } );

    method BUILD ( $params ) {
    	unless ( ref($self) =~ /Message/ or ref($self) =~ /Command::/ or ref($self) =~ /::Table/ ) {
    		$self->log->write(ref($self) . ' loaded.') ;
    	}
    }

    method model ( Str $model_name ) {
        return $self->models->{ lc($model_name) } if ( $self->models->{ lc($model_name) } );
        warn ref($self) . ' tried to reference model "' . $model_name . '" even though it does not exist.';
        return;
    }

    method search_ios ( Str $io_search ) {
        foreach my $io ( keys %{ $self->ios } ) {
            if ( $io =~ /$io_search/ ) {
                return $self->ios->{$io};
            }
        }
        return;
    }

    method dispatch_message ( Str $io_path, whatbot::Message $message ) {
        my ( $io_search, $target ) = split( /\:/, $io_path );
        my $io = $self->search_ios($io_search);
        return unless ($io);
        $message->to($target) if ($target);
        return $io->event_message($message);
    }

    method send_message ( Str $io_path, whatbot::Message $message ) {
        my ( $io_search, $target ) = split( /\:/, $io_path );
        my $io = $self->search_ios($io_search);
        return unless ($io);
        $message->from( $io->me );
        $message->to($target) if ($target);
        return $io->send_message($message);
    }
}

1;

=pod

=head1 NAME

whatbot::Component - Base component for all whatbot modules.

=head1 SYNOPSIS

 use Moose;
 extends 'whatbot::Component';
 
 $self->log->write('I am so awesome.');

=head1 DESCRIPTION

whatbot::Component is the base component for all whatbot modules. This requires
a little bit of magic from the caller, as the accessors all need to be filled
by whatbot::Controller, or the calling method needs to pass 'base_component'
to the Component subclass to fill the proper accessors.

=head1 LICENSE/COPYRIGHT

Be excellent to each other and party on, dudes.

=cut
