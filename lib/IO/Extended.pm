# Author: Murat Uenalan (muenalan@cpan.org)
#
# Copyright (c) 2001 Murat Uenalan. All rights reserved.
#
# Note: This program is free software; you can redistribute
#
# it and/or modify it under the same terms as Perl itself.

=pod

=head1 NAME

IO::Extended - more print functions

=head1 SYNOPSIS

  use IO::Extended ':all';

    printl 'foo bar';

    println 'foo bar';

    printfln 'foo %s', 'bar';

    $str = sprintfln 'foo %s', 'bar';

    warnfln 'foo %s', 'bar';

    diefln 'foo %s', 'bar';

    tabs 5;

    ind 1;

    indn;

    indb;

    indstr;

=head1 DESCRIPTION

IO::Extended contains a bunch of print-like functions, which automatically add
newline characters to the string.

=head1 EXPORT

None by default.

This functions of this module need to be exported before use. Use the ':all' syntax
for automatically adding the complete set.

=cut

package IO::Handle;

sub printfln
{
    @_ >= 2 or die 'usage: $io->printf(FMT,[ARGS])';

    my $this = shift;

	if( my $indent = IO::Extended::indstr() )
	{
		print $this $indent;
	}

    printf $this @_;

    print $this "\n";
}

sub println
{
    @_ or die 'usage: $io->print(ARGS)';

    my $this = shift;

	if( my $indent = IO::Extended::indstr() )
	{
		print $this $indent;
	}

	push @_, $_ unless @_;

    print $this @_ , "\n";
}

sub printl
{
    @_ or die 'usage: $io->print(ARGS)';

    my $this = shift;

	if( my $indent = IO::Extended::indstr() )
	{
		print $this $indent;
	}

    print $this @_;
}

package IO::Extended;

require 5.005_62;

use strict;

use warnings;

use Carp;

use Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw( printl println printfln sprintfln warnfln diefln ind indn indb indstr tabs ) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw();

our $VERSION = '0.08';

# Preloaded methods go here.

use subs qw( printl println printfln sprintfln warnfln diefln ind indn indb indstr tabs );

our $_indentation = 0;

our @_indenthistory = ( 0 );

=head1 VARIABLES

=over

=item $IO::Extended::space

=cut

our $space = ' ';

=item $IO::Extended::tabsize

Scalars for constructing tabs. Indentation is done via printing C<space x ( indentation * tabsize )>.

=cut

our $tabsize = 5;

sub _translate_fmt
{

    $_[0] =~ s/((?<!%)%[S|D])/"'".lc $1."'"/ge;
}

=head1 FUNCTIONS

=item printl

Same as normal print, but with indentation.

=cut

sub printl
{
	print indstr() if indstr();

return print @_;
}

=item println

Same as normal print, but adds newline character to the end.

=cut

sub println
{

	push @_, $_ unless @_;

return printl @_, "\n";
}

=item printfln

=cut

sub printfln
{
	my $fmt = shift;

	_translate_fmt( $fmt );

	$fmt .= "\n";

	if( indstr() )
	{
		$fmt = indstr().$fmt;
	}

for( @_ )
{
	carp "undefined value interpolation" unless defined $_ ;
}
	
return printf $fmt, @_;
}

=item sprintfln

Same as normal (s)printf, but adds newline character to the FORMAT string (Result).

=cut

sub sprintfln
{
	my $fmt = shift;

	_translate_fmt( $fmt );

	$fmt .= "\n";

	if( indstr() )
	{
		$fmt = indstr().$fmt;
	}

return sprintf $fmt, @_;
}

=item warnfln

As C<warn>, but accepts a FORMAT string like printfln.

=cut

sub warnfln
{
    warn( sprintfln( @_ ) );
}

=item diefln

As C<die>, but accepts a FORMAT string like printfln.

=cut

sub diefln
{
    die( sprintfln( @_ ) );
}

=item ind( $integer )

Sets the indentation value.

=cut

sub ind
{
	my $indval = shift;

	if( defined $indval )
	{
		if( $indval >= 0 )
		{
			if( $_indenthistory[-1] != $indval )
			{
				push( @_indenthistory, $_indentation = $indval );
			}
		}
		else
		{
			die 'indentation value is out of rang (>=0)';
		}
	}

return $_indentation+0;
}

=item indn

Increases the indentation one value up.

=cut

sub indn
{
	my $indval = ind() || 0;

return ind( $indval + 1 )+0;
}

=item indb

Decreases the indentation on back in its history.

=cut

sub indb
{
	if( @_indenthistory > 0)
	{
		pop @_indenthistory;

		$_indentation = $_indenthistory[-1] if @_indenthistory;
	}
	else
	{
		$_indentation-- if $_indentation > 0;
	}

return $_indentation+0;
}

=item tabs( $integer )

Sets the tabsize for indentation. Returns the actual tabsize if parameter is omitted.

=cut

sub tabs
{
	my $size = shift;

	if( $size >= 0 )
	{
		$tabsize = $size;
	}

return $tabsize;
}

=item indstr

Returns the absolute indentation space.

=cut

sub indstr
{
	return '' unless $_indentation;

return $space x ( $_indentation * $tabsize );
}

1;
__END__

=back

=head1 FORMAT (*printf*)

Barely all format is forwared to the perl internal printf like functions, but
one is translated.

%S or %D in the format string will get translated to C<'%s'> or C<'%d'>. It should help writing

 printfln "Your given string %S is broken.", $string;

[Note] C<$string> could contains confusing whitespaces, for example.

=head1 SUPPORT

By author. Ask comp.lang.perl.misc or comp.lang.perl.module if you have very general
questions.

If all this does not help, contact me under the emailadress below.

=head1 AUTHOR

Murat Uenalan, muenalan@cpan.org

=head1 COPYRIGHT

Copyright (c) 1998-2002 Murat Uenalan. Germany. All rights reserved.

You may distribute under the terms of either the GNU General Public
License or the Artistic License, as specified in the Perl README file.

=head1 SEE ALSO

perl(1). perlfunc

=cut
