package Twinani::Web;
use Mojo::Base 'Mojolicious';
use Twinani::DB;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
  $self->plugin( 'page_navigator' );

  my $config = $self->plugin('Config', { file => 'twinani.conf' }); # ’Ç‰Á
  $self->attr( db => sub { Twinani::DB->new( $config->{db} ) } ); # ’Ç‰Á

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('root#index');
  $r->get('eat')->to('eat#index');
  $r->get('buy')->to('buy#index');
  $r->get('read')->to('read#index');
  $r->get('look')->to('look#index');
  $r->get('go')->to('go#index');

}

1;
