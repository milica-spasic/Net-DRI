## Domain Registry Interface, .FI policy on reserved names
## Contributed by Mladen Gligorijevic from Atomia AB
##
## Copyright (c) 2006-2010 Patrick Mevzek <netdri@dotandco.com>. All rights reserved.
##
## This file is part of Net::DRI
##
## Net::DRI is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## See the LICENSE file that comes with this distribution for more details.
#
#  
#
####################################################################################################

package Net::DRI::DRD::FI;

use strict;
use warnings;

use base qw/Net::DRI::DRD/;

use DateTime::Duration;
use Net::DRI::Util;
use Net::DRI::Data::Contact::FI;

our $VERSION=do { my @r=(q$Revision: 1.9 $=~/\d+/g); sprintf("%d".".%02d" x $#r, @r); };

## Only transfer requests and queries are possible, the rest is handled "off line".
#__PACKAGE__->make_exception_for_unavailable_operations(qw/domain_transfer_stop domain_transfer_accept domain_transfer_refuse domain_delete/);

=pod

=head1 NAME

Net::DRI::DRD::FI - .FI policies for Net::DRI

=head1 DESCRIPTION

Please see the README file for details.

=head1 SUPPORT

For now, support questions should be sent to:

E<lt>netdri@dotandco.comE<gt>

Please also see the SUPPORT file in the distribution.

=head1 SEE ALSO

E<lt>http://www.dotandco.com/services/software/Net-DRI/E<gt>

=head1 AUTHOR

Patrick Mevzek, E<lt>netdri@dotandco.comE<gt>

=head1 COPYRIGHT

Copyright (c) 2006-2010 Patrick Mevzek <netdri@dotandco.com>.
All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

See the LICENSE file that comes with this distribution for more details.

=cut

####################################################################################################

sub new
{
 my $class=shift;
 my $self=$class->SUPER::new(@_);
 $self->{info}->{host_as_attr}=0;
 $self->{info}->{contact_i18n}=1;
 bless($self,$class);
 return $self;
}

sub name     { return 'fi'; }
sub tlds     { return ('FI'); }
sub periods  { return map { DateTime::Duration->new(months => $_) } (12..120); }
sub object_types { return ('domain','contact','ns'); }
sub profile_types { return qw/epp/; }

sub transport_protocol_default
{
 my ($self,$type)=@_;

 return ('Net::DRI::Transport::Socket',{remote_host=>'epptest.ficora.fi',remote_port=>700},'Net::DRI::Protocol::EPP::Extensions::FI',{}) if $type eq 'epp';
 return;
}

####################################################################################################

sub verify_name_domain
{
 my ($self,$ndr,$domain,$op)=@_;
 return $self->_verify_name_rules($domain,$op,{check_name_no_dots => 1,
                                               my_tld_not_strict => 1,
                                              });
}

####################################################################################################
1;
