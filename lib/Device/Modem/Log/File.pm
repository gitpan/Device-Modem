# $Id: File.pm,v 1.5 2002/04/12 05:13:53 cosimo Exp $
package Device::Modem::Log::File;
$VERSION = substr q$Revision: 1.5 $, 10;

use strict;
use warnings;

sub new {
	my( $class, $package, $filename ) = @_;

	# Get a decent default if no file available
	$filename ||= default_filename();

	my %obj = (
		file => $filename,
		loglevel => 'info'
	);

	bless \%obj, 'Device::Modem::Log::File';
}

# provide a suitable filename default
sub default_filename() {
	my $cDir = '/var/log';

	# If this is windoze (XXX 2000/XP? WINBOOTDIR?)
	if( $^O =~ /Win/i ) {
		$cDir = $ENV{'WINBOOTDIR'} || '/windows';
		$cDir .= '/temp';
	}

	return $cDir.'/modem.log';
}

sub filename {
	my $self = shift();
	$self->{'file'};
}

sub write($$) {
	my($self, $level, @msg) = @_;
	if( open(LOGFILE, '>>'.$self->{'file'}) ) {
		map { tr/\r\n/^M/s } @msg;
		print LOGFILE join("\t", scalar localtime, $0, $level, @msg), "\n";
		close LOGFILE;
	} else {
		warn('cannot log '.$level.' '.join("\t",@msg).' to file: '.$! );
	}

}

sub close { 1 }

1;

__END__

=head1 NAME

Device::Modem::Log::File - Device::Modem log hook class for logging devices activity to text files

=head1 SYNOPSIS

  use Device::Modem;

  my $box = Device::Modem->new( log => 'file', ... );
  my $box = Device::Modem->new( log => 'file,name=/var/log/mymodem.log', ... );
  ...

=head1 DESCRIPTION

This is meant for an example log class to be hooked to Device::Modem
to provide one's favourite logging mechanism.
You just have to implement your own C<new()>, C<write()> and C<close()> methods.

Default text file is C</var/log/modem.log>. On Windows platforms, this
goes into C<[WINDOWS]/temp/modem.log>.

Loaded automatically by B<Device::Modem> class when an object
is instantiated, and it is the B<default> logging mechanism for
B<Device::Modem> class.

=head2 REQUIRES

Device::Modem

=head2 EXPORT

None

=head1 AUTHOR

Cosimo Streppone, cosimo@cpan.org 

=head1 COPYRIGHT

This library is free software; you can only redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Device::Modem>
L<Device::Modem::Log::Syslog>

=cut