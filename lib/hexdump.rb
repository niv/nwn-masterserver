# (C) Copyright 2004 by Tilo Sloboda <tools@unixgods.org>
# (C) Copyright 2007 by Bernhard Stoeckner <elven@swordcoast.net>
#
# License:
#         Freely available under the terms of the OpenSource "Artistic License"
#         in combination with the Addendum A (below)
#
#         In case you did not get a copy of the license along with the software,
#         it is also available at:   http://www.unixgods.org/~tilo/artistic-license.html
#
# Addendum A:
#         THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU!
#         SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
#         REPAIR OR CORRECTION.
#
#         IN NO EVENT WILL THE COPYRIGHT HOLDERS  BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL,
#         SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY
#         TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED
#         INACCURATE OR USELESS OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM
#         TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF THE COPYRIGHT HOLDERS OR OTHER PARTY HAS BEEN
#         ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.


class String
	#
	# returns out a good'ol hexdump of the data contained in the string
	#
	# parameters:     sparse:   true / false     do we want to print multiple lines with zero values?

	def hexdump(sparse = false)
		ret = ""
		selfsize = self.size
		first = true

		# print "\n index       0 1 2 3  4 5 6 7  8 9 A B  C D E F\n\n"

		lines,rest = selfsize.divmod(16)
		address = 0; i = 0    # we count them independently for future extension.

		while lines > 0
			str = self[i..i+15]
			
			# we don't print lines with all zeroes, unless it's the last line
			if str == "\0"*16     # if the 16 bytes are all zero
				if (!sparse) || (sparse &&  lines == 1 && rest == 0)
					str.tr!("\000-\037\177-\377",'.')
					ret += sprintf( "%08x: %4s %4s %4s %4s %4s %4s %4s %4s  %s\n", 
						address,
						self[i..i+1].unpack('H4'), self[i+2..i+3].unpack('H4'),
						self[i+4..i+5].unpack('H4'), self[i+6..i+7].unpack('H4'),
						self[i+8..i+9].unpack('H4'), self[i+10..i+11].unpack('H4'),
						self[i+12..i+13].unpack('H4'), self[i+14..i+15].unpack('H4'),
					str)
				else
					ret += "  ....      00 .. 00 00 .. 00 00 .. 00 00 .. 00    ................\n" if first
					first = false
				end
			else  # print string which is not all zeros
				str.tr!("\000-\037\177-\377",'.')
				ret += sprintf( "%08x: %4s %4s %4s %4s %4s %4s %4s %4s  %s\n", 
					address,
					self[i..i+1].unpack('H4'), self[i+2..i+3].unpack('H4'),
					self[i+4..i+5].unpack('H4'), self[i+6..i+7].unpack('H4'),
					self[i+8..i+9].unpack('H4'), self[i+10..i+11].unpack('H4'),
					self[i+12..i+13].unpack('H4'), self[i+14..i+15].unpack('H4'),
				str)
				first = true
			end
			i += 16; address += 16; lines -= 1
		 end
		 
		 # now do the remaining bytes, which don't fit a full line..
		 # yikes - this is truly ugly!  REWRITE THIS!!

		 if rest > 0
				chunks2,rest2 = rest.divmod(4)     
				j = i; k = 0
				if (i < selfsize)
					ret += sprintf( "%08x: ", address)
					while (i < selfsize)
						ret += sprintf "%02x", self[i]
						i += 1; k += 1
						ret += " " if ((i % 2) == 0)
					end
					for i in (k..15)
						ret += "  "
					end
					str = self[j..selfsize]
					str.tr!("\000-\037\177-\377",'.')
					ret += " " * (4 - chunks2+1)
					ret += sprintf("  %s\n", str)
				end
		 end
		 ret
	end

end
