
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "OAuth2 services for Catalyst",
  "AUTHOR" => "Eden Cardim <edencardim\@gmail.com>",
  "BUILD_REQUIRES" => {
    "Catalyst" => 0,
    "Catalyst::Controller" => 0,
    "Catalyst::Controller::ActionRole" => 0,
    "Catalyst::Model::DBIC::Schema" => 0,
    "Catalyst::Plugin::ConfigLoader" => 0,
    "CatalystX::Test::MockContext" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "HTTP::Request" => 0,
    "HTTP::Request::Common" => 0,
    "Plack::Test" => 0,
    "SQL::Translator" => "0.11006",
    "Test::Exception" => 0,
    "Test::MockObject" => 0,
    "Test::More" => 0,
    "Test::WWW::Mechanize::PSGI" => 0,
    "namespace::autoclean" => 0,
    "strict" => 0,
    "strictures" => 1,
    "warnings" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "CatalystX-OAuth2",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "CatalystX::OAuth2",
  "PREREQ_PM" => {
    "Class::Load" => 0,
    "DBIx::Class" => 0,
    "DBIx::Class::Schema" => 0,
    "JSON::Any" => 0,
    "LWP::UserAgent" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "Moose::Util" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "MooseX::NonMoose" => 0,
    "MooseX::SetOnce" => 0,
    "MooseX::Types::Common::String" => 0,
    "Scalar::Util" => 0,
    "Try::Tiny" => 0,
    "URI" => 0,
    "base" => 0,
    "parent" => 0
  },
  "VERSION" => "0.001002",
  "test" => {
    "TESTS" => "t/*.t t/integration/*.t t/unit/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



