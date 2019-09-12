# Blog

ブログシステム

## Ruby version

- See `.ruby-version`.

## Rails version

- See `Gemfile`.

## System dependencies

- MySQL >= 5.5
- Redis
- Node.js >= 6.0.0
- Yarn >= 0.20.1

## Project initiation

- リポジトリのクローン

```bash
$ git@github.com:startup-technology/runteq_curriculum_advanced.git
```

- Gemのインストール

```bash
$ bundle install --path vendor/bundle
```

- npmのインストール

```bash
$ yarn install
```

### Configuration

*ファイルの中身はご自身の環境に合わせて適宜変更してください*

- データベースの設定

```bash
$ cp config/database.yml.default config/database.yml
```

- 環境変数の設定

```bash
$ cp .env.default .env
```

*AWSのアクセスキーなどは個別に担当者に聞いてください。*

### Database creation

```bash
$ bundle exec rails db:create db:reset
```

### Database initialization

```bash
$ bundle exec rails db:seed
```

## Run rails server

```bash
$ bundle exec rails server
```

## Webpacker

JavaScriptのコンパイル

```
$ ./bin/webpack
```

サーバーの起動

```
$ ./bin/webpack-dev-server
```

```bash
$ spring rspec spec/[対象ファイル]
```

## How to run the static code analysis

### Rubocop

```bash
$ bundle exec rubocop -R
```

### Reek

```bash
$ bundle exec reek
```

### Rails best practices

```bash
$ bundle exec rails_best_practices
```

### Brakeman

```bash
$ bundle exec brakeman
```

### ESLint

```bash
$ npm run lint
```

### SCSS-Lint

```bash
$ bundle exec scss-lint
```

### Slim-Lint

```bash
$ bundle exec slim-lint
```

## Development controller

### Force login

- See `app/controllers/development/sessions_controller.rb`

```
/login_as/[user_id]
```

