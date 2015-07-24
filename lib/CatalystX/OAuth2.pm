package CatalystX::OAuth2;
use Moose::Role;

# ABSTRACT: OAuth2 services for Catalyst


requires '_build_query_parameters';

# spec isn't clear re missing endpoint uris
has redirect_uri  => ( is => 'ro', required => 0 );

has store => (
  is        => 'rw',
  does      => 'CatalystX::OAuth2::Store',
  init_arg  => undef,
  predicate => 'has_store'
);

has query_parameters => ( is => 'rw', init_arg => undef, lazy_build => 1 );

sub _params {qw(response_type redirect_uri scope state client_id)}

sub BUILD {
  my ( $self, $args ) = @_;
  delete @{$args}{ $self->_params() };
  if ( my @extra = keys %$args ) {
    $self->query_parameters(
      { error             => 'invalid_request',
        error_description => 'unrecognized parameters: '
          . join( ', ', @extra )
      }
    );
  }
}


1;

__END__

=pod

=head1 NAME

CatalystX::OAuth2 - OAuth2 services for Catalyst

=head1 VERSION

version 0.001004

=head1 SYNOPSIS

    package AuthServer::Controller::OAuth2::Provider;
    use Moose;
    BEGIN { extends 'Catalyst::Controller::ActionRole' }

    with 'CatalystX::OAuth2::Controller::Role::Provider';

    __PACKAGE__->config(
      store => {
        class => 'DBIC',
        client_model => 'DB::Client'
      }
    );

    sub request : Chained('/') Args(0) Does('OAuth2::RequestAuth') {}

    sub grant : Chained('/') Args(0) Does('OAuth2::GrantAuth') {
      my ( $self, $c ) = @_;

      my $oauth2 = $c->req->oauth2;

      $c->user_exists and $oauth2->user_is_valid(1)
        or $c->detach('/passthrulogin');
    }

    sub token : Chained('/') Args(0) Does('OAuth2::AuthToken::ViaAuthGrant') {}

    sub refresh : Chained('/') Args(0) Does('OAuth2::AuthToken::ViaRefreshToken') {}

    1;

=head1 DESCRIPTION

This module implements the authorization grant subset of the L<oauth 2 ietf
spec draft|http://tools.ietf.org/html/draft-ietf-oauth-v2-23>. Action roles
containing an implementation of each required endpoint in the specification
are provided and should be applied to a L<Catalyst::Controller::ActionRole>.
The authorization grant flow is defined by the specification as follows:

  +--------+                                           +---------------+
  |        |--(A)------- Authorization Grant --------->|               |
  |        |                                           |               |
  |        |<-(B)----------- Access Token -------------|               |
  |        |               & Refresh Token             |               |
  |        |                                           |               |
  |        |                            +----------+   |               |
  |        |--(C)---- Access Token ---->|          |   |               |
  |        |                            |          |   |               |
  |        |<-(D)- Protected Resource --| Resource |   | Authorization |
  | Client |                            |  Server  |   |     Server    |
  |        |--(E)---- Access Token ---->|          |   |               |
  |        |                            |          |   |               |
  |        |<-(F)- Invalid Token Error -|          |   |               |
  |        |                            +----------+   |               |
  |        |                                           |               |
  |        |--(G)----------- Refresh Token ----------->|               |
  |        |                                           |               |
  |        |<-(H)----------- Access Token -------------|               |
  +--------+           & Optional Refresh Token        +---------------+

The action roles should be applied to actions in a single controller, and no
more than one action of each role type should be present.

Here is an overview of what roles are involved in each of those phases:

=over

=item A - L<Catalyst::ActionRole::OAuth2::RequestAuth>

Required

This is the action where the authentication grant flow begins, it validades
and sanitizes the request parameters and generates an authorization code which
is used for issuing a valid request to the GrantAuth action via a redirect.
The authorization code is only generated if all parameters are well-formed and
valid, this ensures that requests to the GrantAuth action can trust the
request parameters if a valid authorization code is presented.

=item B - L<Catalyst::ActionRole::OAuth2::GrantAuth>

Required

This action checks the request parameters for a valid authorization code,
which should have been generated by a previous request to a RequestAuth
action. This action should be customized to somehow confirm with the end-user
if he wishes to effectively grant the authorization to the requesting
client/app. The user-agent is redirected automatically to the correct endpoint
if the authorization is granted.

=item C and D - L<Catalyst::ActionRole::OAuth2::AuthToken::ViaAuthGrant>

Required

This action exchanges a valid authorization grant code and responds with an
authorization token.

=item G and H - L<Catalyst::ActionRole::OAuth2::AuthToken::ViaRefreshToken>

Optional

This action exchanges a valid refresh token for a new access token and refresh
token.

=back

=head1 CONFIGURATION

=head2 store

Takes a hashref containing two keys:

=over

=item class

The store type to use, so far, only DBIC support is provided

=item client_model

The entity representing the client in your schema

=back

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored its development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR

Eden Cardim <edencardim@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Suretec Systems Ltd.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
