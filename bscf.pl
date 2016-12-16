#!/usr/bin/perl -w
# ======================================================================
#
# Perl Source File -- Created with BurnSoft BurnPad
#
# NAME: <cleanfiles.pl>
#
# AUTHOR: BurnSoft www.burnsoft.net
# DATE  : 3/9/2007
#
# PURPOSE: This script was created to delete select file types that are
#           x amount of days old.
#
# ======================================================================
use strict;
$| = 1;
my $VERSION    = '0.55.99';
my $OLDER      = 1;             #Delete older files else delete newer files
my $REPORTMODE = 0;             #Report the files instead of delete
my $DEBUG      = 1;
exit &ListHelp unless $ARGV[0];

my $MAXDAYS = $ARGV[0];         #Number of days from current
my $PATTERN = $ARGV[1];         #File Type
my $DIR     = $ARGV[2] || ".";  #Default to current if blank.
my $msg     = $OLDER ? 'older then' : 'newer then';

&StartingReport;
&dosearch;
&EndReport;
sub ListHelp
{
  print "Created by BurnSoft 2007 ( www.burnsoft.net )\n";
  print "\n";
  print "This script will delete all files or select file types\n";
  print "that are older then X amount of days.\n";
  print "\n";
  print "USAGE: perl cleanfiles.pl <DAYSOLD> <FILETYPE> <DIRECTORY>\n";
  print "\n";
  print "Windows Example:\n";
  print "perl cleanfiles.pl 5 log c:\\temp\\ \n";
  print "UNIX Example:\n";
  print "perl cleanfiles.pl 5 log /tmp/  \n";
  print "\n";
  sleep(5);
}

sub EndReport
{
  print "\nScript Completed!\n";
  sleep(3);
}

sub StartingReport
{
  print "Deleting files type $PATTERN from $DIR that are $msg $MAXDAYS days.\n";
  sleep(3);
}
sub ShowDebug{
  ($msg) = @_;
  if ($DEBUG){
    print "DEBUG: $msg\n";
  }
}
sub dosearch
{
  opendir(DIR, $DIR) or die "can't opendir $DIR: $!";
  my $time = time();
  print "Searching";
  
  while (my $f = readdir(DIR)) {
    next if $f =~ /^\./;
      if ($DEBUG){
          &ShowDebug($f);
      }
      else {
          print ".";
      }
      sleep(1);

      my @FILELIST = split(/\.([a-z]+)$/i,$f);
      my $itemcount = @FILELIST;
      my $ext = $FILELIST[$itemcount - 1];
      #print "Arry Item Count: $itemcount\n";
      next unless $ext =~ /^$PATTERN$/;
      if ($DEBUG){
          print "file matching pattern: $f\n";
          sleep(3);
      }
      my $fullfile = $DIR;
      $fullfile .= $f;
      my ($atime, $mtime, $ctime) = (stat($fullfile))[8..10];
      my $age_hours = ($time - $mtime) / 3600;
      my $age_days = int($age_hours /24);
      
      if ($OLDER) {
        next unless $age_days > $MAXDAYS;
      }
      else{
        next unless $age_days < $MAXDAYS;
      }
      print "\n----> Deleting $fullfile ($age_days days > $MAXDAYS)....";
      if ($REPORTMODE) {
          print "$fullfile was deleted\n"
      }
      else {
          unlink $fullfile;
          #rmdir $fullfile;
          print " done\n";
      }
  }
  closedir(DIR);
}
