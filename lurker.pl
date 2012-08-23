use strict;
use warnings;
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

sub lurkhandle {
  my($text, $server, $win_item) = @_;
  if($win_item && ($text =~ m/win\s*\d+/ || $text =~ m/^(f|j|k|\s|~|>|\.)+$/ )) {
    $win_item->print("Spamblock: " . $text);
    Irssi::signal_stop();
  } else {
    Irssi::signal_continue($text, $server, $win_item);
  }
}
