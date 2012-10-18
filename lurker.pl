use strict;
use warnings;
use Data::Dumper;
use 5.010;

use vars qw($VERSION %IRSSI);

use Irssi;
use Data::Dumper;

$VERSION = '1.00';

%IRSSI = (
  authors => 'Matthew McPherrin',
  contact => 'matthew@mcpherrin.ca',
  name => 'Lurker',
  description => 'Lurk moar',
  license => "CC BY",
);

Irssi::signal_add_first 'send text', 'lurkhandle';

my $lurkchannels = {};
$lurkchannels->{'#csc-test'} = "yes";

sub lurk_cmd {
  my($data, $server, $win_item) = @_;
  if($win_item) {
    if( $lurkchannels->{$win_item->{name}} ) {
      $win_item->print("Already lurking in " . $win_item->{name});
    } else {
      $win_item->print("Now lurking in " . $win_item->{name});
    }
    $lurkchannels->{$win_item->{name}} = "yes";
  } else {
    print "No window.";
  }
}

Irssi::command_bind('lurk', 'lurk_cmd');

sub unlurk_cmd {
  my($data, $server, $win_item) = @_;
  if($win_item) {
    if( $lurkchannels->{$win_item->{name}} ) {
      $win_item->print("Stopped lurking in " . $win_item->{name});
    } else {
      $win_item->print("Was not lurking in " . $win_item->{name});
    }
    delete $lurkchannels->{$win_item->{name}};
  } else {
    print "No window...";
  }
}

Irssi::command_bind('unlurk', 'unlurk_cmd');

sub lurkhandle {
  my($text, $server, $win_item) = @_;
  if($win_item && ($text =~ m/win\s*\d+/ || $text =~ m/^(f|j|k|\s|~|>|\.)+$/ )) {
    $win_item->print("Spamblock: " . $text);
    Irssi::signal_stop();
  } else {
    if( $lurkchannels->{$win_item->{name}} ) {
      $win_item->print("Lurkblock: " . $text);
      Irssi::signal_stop();
    } else {
      Irssi::signal_continue($text, $server, $win_item);
    }
  }
}
