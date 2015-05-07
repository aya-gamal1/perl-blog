package blog::Controller::comments;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

blog::Controller::comments - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched blog::Controller::comments in comments.');
}

sub base :Chained('/') :PathPart('comments'):CaptureArgs(0) {
my ($self, $c) = @_;
$c->stash(resultset => $c->model('DB::Post'));

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
