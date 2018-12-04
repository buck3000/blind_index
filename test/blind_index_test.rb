require_relative "test_helper"

class BlindIndexTest < Minitest::Test
  def setup
    User.delete_all
  end

  def test_find_by
    create_user
    assert User.find_by(email: "test@example.org")
  end

  def test_find_by_string_key
    create_user
    assert User.find_by({"email" => "test@example.org"})
  end

  def test_dynamic_finders
    user = create_user
    assert User.find_by_email("test@example.org")
    assert User.find_by_id_and_email(user.id, "test@example.org")
  end

  def test_where
    create_user
    assert User.where(email: "test@example.org").first
  end

  def test_where_string_key
    create_user
    assert User.where({"email" => "test@example.org"}).first
  end

  def test_where_not
    create_user
    assert User.where.not(email: "test2@example.org").first
  end

  def test_where_not_empty
    create_user
    assert_nil User.where.not(email: "test@example.org").first
  end

  def test_expression
    create_user
    assert User.where(email_ci: "TEST@example.org").first
  end

  def test_expression_different_case
    create_user email: "TEST@example.org"
    assert User.where(email_ci: "test@example.org").first
  end

  def test_encode
    user = create_user
    assert User.find_by(email_binary: "test@example.org")
    assert_equal 32, user.encrypted_email_binary_bidx.bytesize
  end

  def test_validation
    create_user
    user = User.new(email: "test@example.org")
    assert !user.valid?
    assert_equal "Email has already been taken", user.errors.full_messages.first
  end

  def test_validation_case_insensitive
    create_user
    user = User.new(email: "TEST@example.org")
    assert !user.valid?
    assert_equal "Email ci has already been taken", user.errors.full_messages.first
  end

  def test_nil
    user = create_user(email: nil)
    assert_nil user.encrypted_email_bidx
    assert User.where(email: nil).first
    assert_nil User.where(email: "").first
  end

  def test_empty_string
    user = create_user(email: "")
    assert user.encrypted_email_bidx
    assert User.where(email: "").first
    assert_nil User.where(email: nil).first
  end

  def test_unset
    user = create_user
    user.email = nil
    user.save!
    assert_nil user.encrypted_email_bidx
    assert User.where(email: nil).first
  end

  def test_class_method
    user = create_user
    assert_equal user.encrypted_email_bidx, User.compute_email_bidx("test@example.org")
  end

  def test_secure_key
    error = assert_raises(BlindIndex::Error) do
      BlindIndex.generate_bidx("test@example.org", key: "bad")
    end
    assert_equal "Key must use binary encoding", error.message
  end

  # def test_secure_key_ascii
  #   error = assert_raises(BlindIndex::Error) do
  #     BlindIndex.generate_bidx("test@example.org", key: ("0"*32).encode("BINARY"))
  #   end
  #   assert_equal "Key must not be ASCII", error.message
  # end

  def test_secure_key_length
    error = assert_raises(BlindIndex::Error) do
      BlindIndex.generate_bidx("test@example.org", key: SecureRandom.random_bytes(20))
    end
    assert_equal "Key must be 32 bytes", error.message
  end

  def test_inheritance
    assert_equal %i[email email_ci email_binary initials], User.blind_indexes.keys
    assert_equal %i[email email_ci email_binary initials child], ActiveUser.blind_indexes.keys
  end

  def test_initials
    skip unless ActiveRecord::VERSION::MAJOR >= 5

    user = create_user(first_name: "Test", last_name: "User")
    assert User.find_by(initials: "TU")

    user = User.last
    user.email = "test2@example.org"
    user.save!
    assert User.find_by(initials: "TU")
  end

  def test_pbkdf2_sha384
    key = hex2bin("dcc130941b90e0d89ad32bab318535a49b551afb7e70f3033096736280720fa7")
    expected = hex2bin("7880eccb024cd0ca4d2b623c9b4a0d59ff5b29c8a56746bcafd2c0291f05e179")
    value = "secret"
    assert_equal expected, BlindIndex.generate_bidx(value, key: key, algorithm: :pbkdf2_sha384, encode: false)
  end

  def test_argon2id
    key = hex2bin("dcc130941b90e0d89ad32bab318535a49b551afb7e70f3033096736280720fa7")
    expected = hex2bin("05c8a7e6c34059fb91e805340265807aaf3362478d6a6f1acd9031b7a5367782")
    value = "secret"
    assert_equal expected, BlindIndex.generate_bidx(value, key: key, algorithm: :argon2id, encode: false)
  end

  private

  def hex2bin(str)
    [str].pack("H*")
  end

  def create_user(email: "test@example.org", **attributes)
    User.create!({email: email}.merge(attributes))
  end
end
