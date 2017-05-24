#!/usr/bin/perl
# ~/bin/w
# Search for potentially misspelled words
# Output is:
# misspellled
# woord (WOORD, Woord, woord, woord's)

# originally this was a dict of all words
# but sorting it overflowed
%a = ();
# now we have a dict per letter

# read all input
while (<>) {
  next unless /./;
  s/^/ /;
  while (s/([^\\])\\[rtn]/$1 /g) {}
  s/[^a-zA-Z']+/ /g;
  while (s/([A-Z]{2,})([A-Z][a-z]{2,})/ $1 $2 /g) {}
  while (s/([a-z']+)([A-Z])/$1 $2/g) {}
  for $x (split /\s+/, $_) {
    $x =~ s/^'+(.*)/$1/;
    $x =~ s/(.*)'+$/$1/;
    next unless $x =~ /./;
    my $k = lc $x;
    $k =~ s/'[sd]$//;
    my $c = substr $k, 0, 1;
    $a{$c} = () unless defined $a{$c};
    my %l = ();
    %l = %{$a{$c}{$k}} if defined $a{$c}{$k};
    $l{$x} = 1;
    $a{$c}{$k} = \%l;
  }
}
# group related words
for my $c (sort keys %a) {
  for my $s (sort keys($a{$c})) {
    my $k = $s;
    if ($k =~ /.s$/) {
      if ($k =~ /ies$/) {
        $k =~ s/ies$/y/;
      } else {
        $k =~ s/s$//;
      }
    } elsif ($k =~ /.[^aeiou]ed$/) {
      $k =~ s/ed$//;
    } else {
      next;
    }
    next unless defined $a{$c}{$k};
    my %l = %{$a{$c}{$k}};
    for $w (keys($a{$c}{$s})) {
      $l{$w} = 1;
    }
    $a{$c}{$k} = \%l;
    delete $a{$c}{$s};
  }
}
# exclude dictionary words
open DICT, '<', '/usr/share/dict/words';
while ($w = <DICT>) {
  chomp $w;
  my $lw = lc $w;
  my $c = substr $lw, 0, 1;
  next unless defined $a{$c}{$lw};
  delete $a{$c}{$w}; 
  next if $lw eq $w;
  my %l = %{$a{$c}{$lw}}; 
  delete $l{$w};
  if (%l) {
    $a{$c}{$lw} = \%l;
  } else {
    delete $a{$c}{$lw};
  }
}
close DICT;
# display the remainder
for my $c (sort keys %a) {
  for $k (sort keys($a{$c})) {
    my %l = %{$a{$c}{$k}};
    my @w = keys(%l);
    if (scalar(@w) > 1) {
      print $k." (".(join ", ", sort { length($a) <=> length($b) || $a cmp $b } @w).")";
    } else {
      print $w[0];
    }
    print "\n";
  }
}
