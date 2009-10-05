#!/usr/local/bin/perl -- -*- C -*-



# cgi-lib version 3.0
# This was the old way of doing CGI. 
# It was adapted once to handle get and post style inputs
# Now (Dec 2007) we do the new way- with CGI
# But this is here for compatibility.
# Copylefted as applicable.  It is more fun to code than to sue.
# and usable in copyright,  It is better to be paid than be broke.
# It is better to be 

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);


# Perl Routines to Manipulate CGI input
# S.E.Brenner@bioc.cam.ac.uk
# $Header$
#
# Copyright 1994 Steven E. Brenner  
# Unpublished work.
# Permission granted to use and modify this library so long as the
# copyright above is maintained, modifications are documented, and
# credit is given for any use of the library.
#
# Thanks are due to many people for reporting bugs and suggestions
# especially Meng Weng Wong, Maki Watanabe, Bo Frese Rasmussen,
# Andrew Dalke, Mark-Jason Dominus and Dave Dittrich.

# For more information, see:
#     http://www.bio.cam.ac.uk/web/form.html       
#     http://www.seas.upenn.edu/~mengwong/forms/   

# Minimalist http form and script (http://www.bio.cam.ac.uk/web/minimal.cgi):
#
# require "cgi-lib.pl";
# if (&ReadParse(*input)) {
#    print &PrintHeader, &PrintVariables(%input);
# } else {
#   print &PrintHeader,'<form><input type="submit">Data: <input name="myfield">';
#}

# ReadParse
# Reads in GET or POST data, converts it to unescaped text, and puts
# one key=value in each member of the list "@in"
# Also creates key/value pairs in %in, using '\0' to separate multiple
# selections

# Returns TRUE if there was input, FALSE if there was no input 
# UNDEF may be used in the future to indicate some failure.

# Now that cgi scripts can be put in the normal file space, it is useful
# to combine both the form and the script in one place.  If no parameters
# are given (i.e., ReadParse returns FALSE), then a form could be output.

# If a variable-glob parameter (e.g., *cgi_input) is passed to ReadParse,
# information is stored there, rather than in $in, @in, and %in.

sub ReadParse {
  local (*in) = @_ if @_;
  local ($i);

  $cgi_query = new CGI;
  return &setInput($cgi_query);

}


sub setInput {
  local ($query,*in) = @_ if @_;
  local ($i);

  $i=0;
  foreach my $key ($query->param()) {
    local @vala = ($query->param($key));
    local $comma = "";
    local ($j);
    for ($j=0;$j<@vala;$j++) {
      $val = @vala[$j];
      $i+= length($val);
      $in{$key} .= "\0" if (defined($in{$key})); # \0 is the multiple separator
      $in{$key} .= $val;
      }
    }

  return $i; 
}

# PrintHeader
# Returns the magic line which tells WWW that we're an HTML document

sub PrintHeader {
  return "Content-type: text/html\n\n";
}


# MethGet
# Return true if this cgi call was using the GET request, false otherwise

sub MethGet {
  return ($ENV{'REQUEST_METHOD'} eq "GET");
}

# MyURL
# Returns a URL to the script
sub MyURL  {
  return  'http://' . $ENV{'SERVER_NAME'} .  $ENV{'SCRIPT_NAME'};
}

# CgiError
# Prints out an error message which which containes appropriate headers,
# markup, etcetera.
# Parameters:
#  If no parameters, gives a generic error message
#  Otherwise, the first parameter will be the title and the rest will 
#  be given as different paragraphs of the body

sub CgiError {
  local (@msg) = @_;
  local ($i,$name);

  if (!@msg) {
    $name = &MyURL;
    @msg = ("Error: script $name encountered fatal error");
  };

  print &PrintHeader;
  print "<html><head><title>$msg[0]</title></head>\n";
  print "<body><h1>$msg[0]</h1>\n";
  foreach $i (1 .. $#msg) {
    print "<p>$msg[$i]</p>\n";
  }
  print "</body></html>\n";
}

# PrintVariables
# Nicely formats variables in an associative array passed as a parameter
# And returns the HTML string.

sub PrintVariables {
  local (%in) = @_;
  local ($old, $out, $output);
  $old = $*;  $* =1;
  $output .=  "<DL COMPACT>";
  foreach $key (sort keys(%in)) {
    foreach (split("\0", $in{$key})) {
      ($out = $_) =~ s/\n/<BR>/g;
      $output .=  "<DT><B>$key</B><DD><I>$out</I><BR>";
    }
  }
  $output .=  "</DL>";
  $* = $old;

  return $output;
}

# PrintVariablesShort
# Nicely formats variables in an associative array passed as a parameter
# Using one line per pair (unless value is multiline)
# And returns the HTML string.


sub PrintVariablesShort {
  local (%in) = @_;
  local ($old, $out, $output);
  $old = $*;  $* =1;
  foreach $key (sort keys(%in)) {
    foreach (split("\0", $in{$key})) {
      ($out = $_) =~ s/\n/<BR>/g;
      $output .= "<B>$key</B> is <I>$out</I><BR>";
    }
  }
  $* = $old;

  return $output;
}

1; #return true 

