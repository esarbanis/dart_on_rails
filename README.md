# Dart on Rails

This repository contains an example project for applying the [Rails](https://rubyonrails.org/) MVC paradigm
with server-side [Dart](https://dart.dev/).

## Routing

We use [Shelf Router](https://pub.dev/packages/shelf_router) to define our routes.

### Update routes

Edit the [`lib/config/routes.dart`](lib/config/routes.dart) file to update your routes definitions.

## Controllers

We use [Shelf](https://pub.dev/packages/shelf) to define our controllers.

### Add a controller

Add the new controller file in the [`lib/app/controllers`](lib/app/controllers) folder and update the [rollup file](lib/app/controllers/controllers.dart) to expose it.

Make sure the methods of the controller are static and adhere to the `Handler` signature.

eg.
```dart
class Resource {
  static Future<Response> index(Request request) async {
    return Response.ok('Hello World!');
  }
}
```

Note: although it is not necessary, please avoid appending the `Controller` suffix to the controller class name.
It will make the code more readable and also when you use it in the routes file, it will look more fluent.

## Models

We use [Prisma](https://www.prisma.io/) to define our data models and generate the database schema.

### Update schema

Edit the [`prisma/schema.prisma`](prisma/schema.prisma) file to define your data model.

eg.
```prisma
model User {
   id Int @id @default(autoincrement())
   name String
   email String @unique
}
```

### Generate Prisma Client

```bash
$ ./tools/model_gen.sh
```

### Migrate database

```bash
$ ./tools/migrate.sh
```

## Views

We use [jinja](https://github.com/ykmnkmi/jinja.dart) to define our views. **This will change in the future**.

### Add a view

Add the new view file{s} in the [`lib/app/views`](lib/app/views) folder by creating the resource folder and naming it the same as the controller file (eg. `posts/`, `users` etc).