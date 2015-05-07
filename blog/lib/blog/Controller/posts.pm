package blog::Controller::posts;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

blog::Controller::posts - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched blog::Controller::posts in posts.');
}
sub list :Local {
my ($self, $c) = @_;
$c->stash(posts => [$c->model('DB::Post')->all]);
$c->stash(template => 'posts/list.tt');
}


sub base :Chained('/') :PathPart('posts'):CaptureArgs(0) {
my ($self, $c) = @_;
$c->stash(resultset => $c->model('DB::Post'));

}
sub form_new :Chained('base') :PathPart('new')  {
my ($self, $c) = @_;
$c->stash(template => 'posts/new.tt');
}


sub form_create_do :Chained('base') :PathPart('create') :Args(0) {
my ($self, $c) = @_;
my $user_id = $c->request->params->{user_id} || 'N/A';
my $title = $c->request->params->{title} || 'N/A';
my $body = $c->request->params->{body} || 'N/A';

# Create the user
my $post = $c->model('DB::Post')->create({title => $title,body => $body,user_id=>$user_id});
# Store new model object in stash and set template
$c->response->redirect($c->uri_for($self->action_for('list')));
#$c->stash(user => $user,template => 'users/show.tt');
}

#sub show :Chained('base') :PathPart('show')  {
#my ($self, $c) = @_;
#$c->stash(template => 'posts/show.tt');
#}


sub object :Chained('base') :PathPart('id') :CaptureArgs(1){

my ($self, $c,$id) = @_;
$c->stash(object=>$c->stash->{resultset}->find($id));

}

sub delete :Chained('object') :PathPart('delete') :Args(0) { 
my ($self, $c) = @_;
$c->stash->{object}->delete;
$c->response->redirect($c->uri_for($self->action_for('list')));

}


sub show :Chained('object') :PathPart('show')  {
my ($self, $c) = @_;

my $id = $c->stash->{object}->id ;
$c->log->debug($id);

$c->stash(posts=>$c->stash->{object});

$c->stash(comments=> [$c->model('DB::Comment')->search({post_id => $id})]);
$c->stash(template => 'posts/show.tt');
}

sub edit :Chained('object') :PathPart('edit')  {
my ($self, $c) = @_;
$c->stash(posts=>$c->stash->{object});
$c->stash(template => 'posts/edit.tt');
}

sub update :Chained('object') :PathPart('update')  {
my ($self, $c) = @_;
my $id = $c->request->params->{id} || 'N/A';
$c->log->debug($id);
my $title = $c->request->params->{title} || 'N/A';
my $body = $c->request->params->{body} || 'N/A';

# Create the user
 $c->stash->{object}->update(
                        {
					id 	=> $id,
                                	title      =>      $title ,
                                  	body     =>      $body,
       
                });
# Store new model object in stash and set template
$c->response->redirect($c->uri_for($self->action_for('list')));
#$c->stash(user => $user,template => 'users/show.tt');
}





sub createcomment :Chained('object') :PathPart('createcomment') :Args(0) {
my ($self, $c) = @_;

my $user_id = $c->request->params->{user_id} || 'N/A';
my $body = $c->request->params->{body} || 'N/A';
my $id = $c->stash->{object}->id ;
# Create the user
my $comment = $c->model('DB::Comment')->create({body => $body,post_id=>$id,user_id=>$user_id});
# Store new model object in stash and set template
$c->response->redirect($c->uri_for($self->action_for('show'),[$id]));
#$c->stash(user => $user,template => 'users/show.tt');
}

sub deletecomment1 :Chained('object') :PathPart('deletecomment1')  {
my ($self, $c,$cid) = @_;


my $cid= $c->request->params->{id};
$c->log->debug($cid);
my $id = $c->stash->{object}->id ;
$c->log->debug($id);
# Create the user
my $comment = $c->model('DB::Comment')->find( $cid);
$comment->delete;

# Store new model object in stash and set template
$c->response->redirect($c->uri_for($self->action_for('show'),[$id]));
#$c->stash(user => $user,template => 'users/show.tt');
}







=encoding utf8

=head1 AUTHOR

aya,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
