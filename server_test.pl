{ 'Model::DB' => {
    schema_class  => 'AuthServer::Schema',
    connect_info  => [ 'dbi:SQLite:dbname=:memory:', '', '' ],
    user_endpoint => 'http://localhost:5001/auth'
  }
}
