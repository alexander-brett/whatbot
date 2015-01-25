###########################################################################
# Whatbot/Command/Insult.pm
###########################################################################
# Provides insults to other commands, insults on command.
###########################################################################
# the whatbot project - http://www.whatbot.org
###########################################################################

package Whatbot::Command::Insult;
use Moose;
BEGIN { extends 'Whatbot::Command' }
use namespace::autoclean;

has formats =>(
  is => 'ro',
  isa => 'ArrayRef',
  default => sub {[
    '%1$s is the most %2$s in the realm!',
    '%1$s, thou %2$s!',
    '%1$s is a%3$s %2$s.',
    '%1$s, thou\'rt truly a%3$s %2$s.',
    'What a%3$s %2$s is our %1$s.',
   ]});

has adj1 =>(
  is => 'ro',
  isa => 'ArrayRef',
  default => sub {[
    qw'artless bawdy beslubbering bootless churlish cockered clouted craven
       currish dankish dissembling droning errant fawning fobbing froward
       frothy gleeking goatish gorbellied humourless impertinent infectious jarring
       loggerheaded lumpish mammering mangled mewling paunchy pribbling
       puking puny qualling rank reeky roguish ruttish saucy spleeny spongy
       surly tottering unmuzzled vain venomed villainous warped wayward
       weedy yeasty'
   ]});

has adj2 => (
  is => 'ro',
  isa => 'ArrayRef',
  default => sub {[
    qw'base-court bat-fowling beef-witted beetle-headed boil-brained
       clapper-clawed clay-brained common-kissing crook-pated dismal-dreaming
       dizzy-eyed doghearted dread-bolted earth-vexing elf-skinned
       fat-kidneyed fen-sucked flap-mouthed fly-bitten folly-fallen fool-born
       full-gorged guts-griping half-faced hasty-witted hedge-born hell-hated
       idle-headed ill-breeding ill-nurtured knotty-pated milk-livered
       motley-minded onion-eyed plume-plucked pottle-deep pox-marked
       reeling-ripe rough-hewn rude-growing rump-fed shard-borne sheep-biting
       spur-galled swag-bellied tardy-gaited tickle-brained toad-spotted
       unchin-snouted weather-bitten'
   ]});

has noun => (
  is => 'ro',
  isa => 'ArrayRef',
  default => sub {[
    qw'apple-john baggage barnacle bladder boar-pig bugbear bum-bailey
       canker-blossom clack-dish clotpole coxcomb codpiece death-token
       dewberry flap-dragon flax-wench flirt-gill foot-licker fustilarian
       giglet gudgeon haggard harpy hedge-pig horn-beast hugger-mugger
       joithead lewdster lout maggot-pie malt-worm mammet measle minnow
       miscreant moldwarp mumble-news nut-hook pigeon-egg pignut puttock
       pumpion ratsbane scut skainsmate strumpet varlot vassal whey-face
       wagtail'
   ]});

sub register {
	my ($self) = @_;
	$self->command_priority('Primary');
	$self->require_direct(0);
}

sub get_insult {
  my $self = shift;
  return join ' ',
    $self->adj1->[rand @{$self->adj1}],
    $self->adj2->[rand @{$self->adj2}],
    $self->noun->[rand @{$self->noun}];
}

sub format_insult {
  my ($self, $recipient, $insult) = @_;
  sprintf(
    $self->formats->[rand @{$self->formats}],
    $recipient,
    $insult,
    $insult =~ /^[aeiouhwy]/ ? 'n' : '',
   );
}

sub get_recipient {
  my ($self, $message, $captures) = @_;
  if ($captures and @$captures and $captures->[0]) {
    return $captures->[0] =~ /^[mM][eE]$/ ? $message->from : $captures->[0];
  }
  return $message->from;
}

sub throw_insult : CommandRegEx('have at (@?\w+)?') {
  my $self = shift;
  return $self->format_insult($self->get_recipient(@_), $self->get_insult());
}

__PACKAGE__->meta->make_immutable;

1;
