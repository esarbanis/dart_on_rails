# Dart on Rails

## Getting Started

```bash
$ dart create dart_on_rails
$ cd dart_on_rails
```

## Creating models

### Setup ORM ([Prisma](https://prisma.pub/docs/getting-started.html))

```bash
$ npm i prisma
$ npx prisma init
```

### Install client

```bash
$ dart pub add orm
```

### Create models

```prisma
model User {
   id Int @id @default(autoincrement())
   name String
   email String @unique
}
```

### Create schema

```bash
$ npx prisma db push
```