import 'package:meta/meta.dart';

final placeholderStories = <Story>[Story()];

final clapton =
    User(name: 'Clapton Orioste', imageUrl: 'assets/images/me.jpg');
final naruto = User(
    name: 'Naruto',
    imageUrl: 'assets/images/naruto.jpg',
    stories: placeholderStories);
final sasuke = User(
    name: 'Sasuke',
    imageUrl: 'assets/images/sasuke.jpg',
    stories: placeholderStories);
final minato = User(
    name: 'Minato',
    imageUrl: 'assets/images/minato.jpg',
    stories: placeholderStories);
final saitama = User(
    name: 'Saitama',
    imageUrl: 'assets/images/saitama.jpg',
    stories: placeholderStories);
final genus = User(
    name: 'Genus',
    imageUrl: 'assets/images/genus.jpg',
    stories: placeholderStories);

final currentUser = clapton;

class User {
  final String name;

  final String imageUrl;
  final List<Story> stories;

  const User({
    @required this.name,
    this.imageUrl,
    this.stories = const <Story>[],
  });
}

class Like {
  final User user;

  Like({@required this.user});
}

class Story {
  const Story();
}