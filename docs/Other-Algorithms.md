# Other Algorithms

## PBKDF2-SHA256

Use:

```ruby
class User < ApplicationRecord
  blind_index :email, algorithm: :pbkdf2_sha256, ...
end
```

The default number of iterations is 10,000. For highly sensitive fields, set this to at least 100,000.

```ruby
class User < ApplicationRecord
  blind_index :email, algorithm: :pbkdf2_sha256, cost: {iterations: 100000}, ...
end
```

## Argon2i

Add [argon2](https://github.com/technion/ruby-argon2) to your Gemfile and use:

```ruby
class User < ApplicationRecord
  blind_index :email, algorithm: :argon2i, ...
end
```

Set the cost parameters with:

```ruby
class User < ApplicationRecord
  blind_index :email, algorithm: :argon2i, cost: {t: 4, m: 15}, ...
end
```

## scrypt

Add [scrypt](https://github.com/pbhogan/scrypt) to your Gemfile and use:

```ruby
class User < ApplicationRecord
  blind_index :email, algorithm: :scrypt, ...
end
```

Set the cost parameters with:

```ruby
class User < ApplicationRecord
  blind_index :email, algorithm: :scrypt, cost: {n: 4096, r: 8, p: 1}, ...
end
```
