use LWP::UserAgent;
{ 'Plugin::Authentication' => {
    default => {
      credential => {
        class     => 'OAuth2',
        grant_uri => 'http://localhost:5000/request',
        token_uri => 'http://localhost:5000/token',
        client_id => 1,
        ua        => LWP::UserAgent->new
      },
      store => { class => 'Null' }
    }
  }
};
