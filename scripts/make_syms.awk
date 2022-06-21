#!/usr/bin/awk -f
#
# Copyright (C) 2009, 2010 Dan McMahill
# All rights reserved.
#
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

BEGIN {
  FS = "[|]";
}

/^[ \t]*[#*;]/ {
# skip comment lines
	 next;
	 }

/^[ \t]*$/ {
# skip blank lines
  next;
}

# part          | symbol_template | pkg   	|
# pin1,pin2,pin3,...|pin_seq| Comments	| Vendor
{
  gsub(/[ \t]*/, "");
  i=1;
  part = $i; i = i + 1;
  symbol_template = "symbol_templates/" $i; i = i + 1;
  value = $i; i = i + 1;
  footprint = $i; i = i + 1;
  pinout = $i; i = i + 1;
  pinsequence = $i; i = i + 1;
  comments = $i; i = i + 1;
  vendor = $i; i = i + 1;
  num_pins  = split(pinout, pin_number, ",");
  if (num_pins == 0) {
# we will use the default mapping which is @p1@ -> pin 1,
# etc.
    while( getline < symbol_template > 0) {
      if ($0 ~ /^pinnumber=@p[0-9]+@$/) { num_pins++; }
    }
    close (symbol_template);
    
    for (i = 1 ; i <= num_pins ; i++) {
      pin_number[i] = i;
    }
  }
  num_pins2 = split(pinsequence, pin_sequence, ",");
  if (num_pins2 == 0) {
# we will use the default.
    for (i = 1 ; i <= num_pins ; i++) {
      pin_sequence[i] = i;
    }
  } else {
    if (num_pins2 != num_pins) {
      printf("ERROR:  Line %d:  the pin out list and pin sequence list have different lengths (%d versus %d)\n", NR, num_pins, num_pins2) >"/dev/stderr";
      close("/dev/stderr");
      exit(1);
    }
  }

  manufacturer = "";  # FIXME -- should maybe add a field for this
  if( value ~ /^[ \t]*$/ ) { value = part; }

  # strip leading/trailing whitespace from the value
  gsub(/^[ \t]*/, "", value); gsub(/[ \t]*$/, "", value);

  if( manufacturer ~ /^[ \t]*$/ ) { manufacturer = vendor; }

  make_component();
  next;
}

function make_component() {
  outf = "symbols/" part ".sym";
  printf("Creating %s, %d pins, %d pin sequence\n", outf, num_pins, num_pins2);
  system("rm -f " outf);
  while( getline < symbol_template > 0) {
    gsub(/@device@/, part);
    gsub(/@value@/, value);
    gsub(/@manufacturer@/, manufacturer);
    gsub(/@vendor@/, vendor);
    gsub(/@footprint@/, footprint);
    gsub(/@description@/, comments);
    gsub(/@documentation@/, "not implemented yet");
    
    for(i = 1; i <= num_pins ; i++) {
      gsub("@p" i "@", pin_number[i]);
    }
    
    for(i = 1; i <= num_pins ; i++) {
      gsub("@ps" i "@", pin_sequence[i]);
    }
    
    print >> outf;
  }
  close( symbol_template );
  close( outf );
}


